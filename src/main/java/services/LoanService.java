package services;

import dao.AccountDAO;
import dao.LoanDAO;
import dao.TransactionDAO;
import model.Account;
import model.Loan;
import model.Transaction;
import model.Account.AccountStatus;
import model.Loan.LoanStatus;
import services.exception.LoanServiceException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public class LoanService {

	private final LoanDAO loanDAO;
	private final AccountDAO accountDAO;
	private final AccountService accountService;
	private final TransactionDAO transactionDAO;

    private static final BigDecimal MIN_LOAN_AMOUNT      = new BigDecimal("50000");
    private static final BigDecimal MAX_LOAN_AMOUNT      = new BigDecimal("1000000");
    private static final BigDecimal MIN_ACCOUNT_BALANCE  = new BigDecimal("30000");
    private static final BigDecimal DEFAULT_INTEREST_RATE = new BigDecimal("10.5");
    private static final int MAX_ACTIVE_LOANS = 2;

    public LoanService() {
        this.loanDAO          = new LoanDAO();
        this.accountDAO       = new AccountDAO();
        this.accountService   = new AccountService();
        this.transactionDAO   = new TransactionDAO();
    }

    // ─────────────────────────────────────────────
    // 1️⃣ VIEW LOAN OPTIONS
    // ─────────────────────────────────────────────
    public ServiceResult<String> viewLoanOption() {
        String info =
                "Loan Options:\n" +
                "- Minimum Loan Amount: Rs.50,000\n" +
                "- Maximum Loan Amount: Rs.10,00,000\n" +
                "- Interest Rate: 10.5% per annum\n" +
                "- Tenure: Flexible (in months)\n" +
                "- Eligibility: Active account with balance >= Rs.30,000";
        return ServiceResult.success("Loan options fetched successfully", info);
    }

    // ─────────────────────────────────────────────
    // 2️⃣ CHECK LOAN ELIGIBILITY
    // ─────────────────────────────────────────────
    public ServiceResult<Void> checkLoanEligibilty(int accountId, BigDecimal loanAmount) {

        if (loanAmount == null || loanAmount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid loan amount");

        try {
        	ServiceResult<Account> accResult = accountService.getAccountDetails(accountId);

        	if (!accResult.isSuccess())
        	    return ServiceResult.failure(accResult.getMessage());

        	Account account = accResult.getData();

        	if (account.getBalance().compareTo(MIN_ACCOUNT_BALANCE) < 0)
        	    return ServiceResult.failure("Minimum account balance of Rs.30,000 required");

            if (loanAmount.compareTo(MIN_LOAN_AMOUNT) < 0 ||
                loanAmount.compareTo(MAX_LOAN_AMOUNT) > 0)
                return ServiceResult.failure("Loan amount must be between Rs.50,000 and Rs.10,00,000");

            // ── Max 2 active loans check ──
            List<Loan> existingLoans = loanDAO.getLoansByAccountId(accountId);
            long activeCount = existingLoans.stream()
                    .filter(l -> l.getLoanStatus() == LoanStatus.APPROVED
                              || l.getLoanStatus() == LoanStatus.ACTIVE)
                    .count();

            if (activeCount >= MAX_ACTIVE_LOANS)
                return ServiceResult.failure("Maximum 2 active loans allowed per account. Please repay existing loans first.");

            return ServiceResult.success("Account is eligible for loan", null);

        } catch (Exception e) {
            throw new LoanServiceException("Error while checking loan eligibility", e);
        }
    }

    // ─────────────────────────────────────────────
    // 3️⃣ APPLY FOR LOAN
    // ─────────────────────────────────────────────
    public ServiceResult<Loan> applyForLoan(int userId, int accountId,
                                             BigDecimal loanAmount, Integer tenureMonths) {

        if (tenureMonths == null || tenureMonths <= 0)
            return ServiceResult.failure("Invalid tenure");

        try {
            // Eligibility check (includes max loan check)
            ServiceResult<Void> eligibility = checkLoanEligibilty(accountId, loanAmount);
            if (!eligibility.isSuccess())
                return ServiceResult.failure(eligibility.getMessage());

            // EMI calculation
            BigDecimal monthlyRate = DEFAULT_INTEREST_RATE
                    .divide(new BigDecimal("12"), 8, RoundingMode.HALF_UP)
                    .divide(new BigDecimal("100"), 8, RoundingMode.HALF_UP);

            BigDecimal emi = loanAmount
                    .multiply(monthlyRate)
                    .multiply(BigDecimal.ONE.add(monthlyRate).pow(tenureMonths))
                    .divide(
                            BigDecimal.ONE.add(monthlyRate).pow(tenureMonths).subtract(BigDecimal.ONE),
                            2, RoundingMode.HALF_UP);

            // Create loan object
            Loan loan = new Loan();
            loan.setUserId(userId);
            loan.setAccountId(accountId);
            loan.setLoanAmount(loanAmount);
            loan.setInterestRate(DEFAULT_INTEREST_RATE);
            loan.setTenureMonths(tenureMonths);
            loan.setMonthlyEmi(emi);
            loan.setLoanStatus(LoanStatus.APPROVED);
            loan.setStartDate(LocalDate.now());
            loan.setEndDate(LocalDate.now().plusMonths(tenureMonths));

            boolean created = loanDAO.createLoan(loan);
            if (!created)
                return ServiceResult.failure("Loan application failed");

            // ── Credit loan amount to account ──
            ServiceResult<Void> creditResult = accountService.creditAmount(accountId, loanAmount);
            if (!creditResult.isSuccess())
                return ServiceResult.failure("Loan approved but balance update failed");

            // ── CREDIT transaction entry ──
            Transaction creditTx = new Transaction();
            creditTx.setSenderAccountId(null);
            creditTx.setReceiverAccountId(accountId);
            creditTx.setAmount(loanAmount);
            creditTx.setTransactionType(Transaction.TransactionType.CREDIT);
            creditTx.setTransactionStatus(Transaction.TransactionStatus.SUCCESS);
            creditTx.setReferenceId("LOAN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            creditTx.setDescription("Loan disbursement of Rs." + String.format("%,.2f", loanAmount));
            transactionDAO.createTransaction(creditTx);

            return ServiceResult.success("Loan approved successfully", loan);

        } catch (Exception e) {
            throw new LoanServiceException("Error while applying for loan", e);
        }
    }
 // 7️⃣ PAY FULL LOAN
    public ServiceResult<Void> payFullLoan(int loanId, int accountId) {
        try {
            Loan loan = loanDAO.getLoanById(loanId);

            if (loan == null)
                return ServiceResult.failure("Loan not found");

            if (loan.getLoanStatus() == LoanStatus.CLOSED)
                return ServiceResult.failure("This loan is already closed");

            if (loan.getLoanStatus() == LoanStatus.REJECTED)
                return ServiceResult.failure("Cannot pay rejected loan");

            Account account = accountDAO.getAccountById(accountId);
            if (account == null)
                return ServiceResult.failure("Account not found");

            // Total remaining = loanAmount (original principal)
            // Interest already EMI mein included hai
            BigDecimal totalRemaining = loan.getLoanAmount();

            if (account.getBalance().compareTo(totalRemaining) < 0)
                return ServiceResult.failure("Insufficient balance to pay full loan amount");

            // ── Deduct full amount ──
            ServiceResult<Void> debitResult = accountService.debitAmount(accountId, totalRemaining);
            if (!debitResult.isSuccess())
                return ServiceResult.failure(debitResult.getMessage());

            // ── DEBIT transaction entry ──
            Transaction debitTx = new Transaction();
            debitTx.setSenderAccountId(accountId);
            debitTx.setReceiverAccountId(null);
            debitTx.setAmount(totalRemaining);
            debitTx.setTransactionType(Transaction.TransactionType.DEBIT);
            debitTx.setTransactionStatus(Transaction.TransactionStatus.SUCCESS);
            debitTx.setReferenceId("LOAN-CLOSE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            debitTx.setDescription("Full loan repayment for Loan #" + loanId);
            transactionDAO.createTransaction(debitTx);

            // ── Loan status CLOSED karo ──
            loanDAO.updateLoanStatus(loanId, LoanStatus.CLOSED);

            return ServiceResult.success("Loan closed successfully", null);

        } catch (Exception e) {
            throw new LoanServiceException("Error while paying full loan", e);
        }
    }

    // ─────────────────────────────────────────────
    // 4️⃣ PAY EMI MANUALLY
    // ─────────────────────────────────────────────
    public ServiceResult<Void> payEmi(int loanId, int accountId) {
        try {
            Loan loan = loanDAO.getLoanById(loanId);

            if (loan == null)
                return ServiceResult.failure("Loan not found");

            if (loan.getLoanStatus() == LoanStatus.CLOSED)
                return ServiceResult.failure("This loan is already closed");

            if (loan.getLoanStatus() == LoanStatus.REJECTED)
                return ServiceResult.failure("Cannot pay EMI for a rejected loan");

            Account account = accountDAO.getAccountById(accountId);
            if (account == null)
                return ServiceResult.failure("Account not found");

            BigDecimal emi = loan.getMonthlyEmi();
            ServiceResult<Void> debitResult = accountService.debitAmount(accountId, emi);
            if (!debitResult.isSuccess())
                return ServiceResult.failure(debitResult.getMessage());

            // ── DEBIT transaction entry ──
            Transaction debitTx = new Transaction();
            debitTx.setSenderAccountId(accountId);
            debitTx.setReceiverAccountId(null);
            debitTx.setAmount(emi);
            debitTx.setTransactionType(Transaction.TransactionType.DEBIT);
            debitTx.setTransactionStatus(Transaction.TransactionStatus.SUCCESS);
            debitTx.setReferenceId("EMI-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            debitTx.setDescription("EMI payment for Loan #" + loanId);
            transactionDAO.createTransaction(debitTx);

            // ── Pehli EMI ke baad ACTIVE karo ──
            if (loan.getLoanStatus() == LoanStatus.APPROVED) {
                loanDAO.updateLoanStatus(loanId, LoanStatus.ACTIVE);
            }

            return ServiceResult.success("EMI paid successfully", null);

        } catch (Exception e) {
            throw new LoanServiceException("Error while paying EMI", e);
        }
    }

    // ─────────────────────────────────────────────
    // 5️⃣ GET USER LOANS
    // ─────────────────────────────────────────────
    public ServiceResult<List<Loan>> getUserLoans(int userId) {
        try {
            List<Loan> loans = loanDAO.getLoansByUserId(userId);
            return ServiceResult.success("Loans fetched successfully", loans);
        } catch (Exception e) {
            throw new LoanServiceException("Error while fetching user loans", e);
        }
    }

    // ─────────────────────────────────────────────
    // 6️⃣ AUTO EMI (Scheduler ke liye)
    // ─────────────────────────────────────────────
    public void processAutoEmi() {
        try {
            List<Loan> activeLoans = loanDAO.getLoansByStatus(LoanStatus.ACTIVE);

            for (Loan loan : activeLoans) {
                try {
                    Account account = accountDAO.getAccountById(loan.getAccountId());
                    if (account == null) continue;

                    BigDecimal emi = loan.getMonthlyEmi();

                    ServiceResult<Void> debitResult = accountService.debitAmount(loan.getAccountId(), emi);
                    if (!debitResult.isSuccess()) {
                        System.out.println("[EMI Scheduler] Skipped loan #" + loan.getLoanId() + ": " + debitResult.getMessage());
                        continue;
                    }

                    Transaction debitTx = new Transaction();
                    debitTx.setSenderAccountId(loan.getAccountId());
                    debitTx.setReceiverAccountId(null);
                    debitTx.setAmount(emi);
                    debitTx.setTransactionType(Transaction.TransactionType.DEBIT);
                    debitTx.setTransactionStatus(Transaction.TransactionStatus.SUCCESS);
                    debitTx.setReferenceId("AUTO-EMI-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                    debitTx.setDescription("Auto EMI deduction for Loan #" + loan.getLoanId());
                    transactionDAO.createTransaction(debitTx);

                    System.out.println("[EMI Scheduler] EMI deducted for loan #" + loan.getLoanId());

                } catch (Exception e) {
                    System.out.println("[EMI Scheduler] Error for loan #" + loan.getLoanId() + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            throw new LoanServiceException("Error in auto EMI processing", e);
        }
    }
}