package services;

import dao.AccountDAO;
import model.Account;
import model.Account.AccountStatus;
import services.exception.AccountServiceException;

import java.math.BigDecimal;
import java.util.List;

public class AccountService {

    private final AccountDAO accountDAO;

    public AccountService() {
        this.accountDAO = new AccountDAO();
    }

    // 1️⃣ CREATE ACCOUNT
    public ServiceResult<Void> createAccount(Account account) {

        if (account == null)
            return ServiceResult.failure("Account data is required");

        if (account.getUserId() == null)
            return ServiceResult.failure("User ID is required");

        if (account.getAccountNumber() == null || account.getAccountNumber().isEmpty())
            return ServiceResult.failure("Account number is required");

        try {
            // business rule: unique account number
            if (accountDAO.isAccountNumberExists(account.getAccountNumber()))
                return ServiceResult.failure("Account number already exists");

            // default values
            account.setStatus(AccountStatus.ACTIVE);

            boolean created = accountDAO.createAccount(account);

            if (!created)
                return ServiceResult.failure("Account creation failed");

            return ServiceResult.success("Account created successfully", null);

        } catch (Exception e) {
            throw new AccountServiceException("Error while creating account");
        }
    }

    // 2️⃣ GET ACCOUNT DETAILS (single account)
    public ServiceResult<Account> getAccountDetails(int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() == AccountStatus.CLOSED)
                return ServiceResult.failure("Account is closed");

            return ServiceResult.success("Account details fetched", account);

        } catch (Exception e) {
            throw new AccountServiceException("Error while fetching account details");
        }
    }

    // 3️⃣ CHECK BALANCE
    public ServiceResult<BigDecimal> checkBalance(int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Account is not active");

            return ServiceResult.success("Balance fetched successfully",
                    account.getBalance());

        } catch (Exception e) {
            throw new AccountServiceException("Error while checking balance");
        }
    }

    // 4️⃣ SWITCH ACCOUNT (logical switch – frontend/session level)
    public ServiceResult<Account> switchAccount(int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Cannot switch to inactive account");

            // no DB update needed (session handling in servlet)
            return ServiceResult.success("Account switched successfully", account);

        } catch (Exception e) {
            throw new AccountServiceException("Error while switching account");
        }
    }

    // 5️⃣ SET DEFAULT ACCOUNT
    // (default handling usually session-based or separate flag in DB)
    public ServiceResult<Void> setDefaultAccount(int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Only active account can be default");

            // DB change not required here (handled at session / user preference level)
            return ServiceResult.success("Default account set successfully", null);

        } catch (Exception e) {
            throw new AccountServiceException("Error while setting default account");
        }
    }
    // GET ACCOUNTS BY USER ID FOR DASHBOARD
    public ServiceResult<List<Account>> getUserAccounts(int userId) {
        try {
            List<Account> list = accountDAO.getAccountsByUserId(userId);

            if (list.isEmpty())
                return ServiceResult.failure("No accounts found");

            return ServiceResult.success("Accounts fetched", list);

        } catch (Exception e) {
            throw new AccountServiceException("Error fetching accounts");
        }
    }
 // CREDIT AMOUNT (loan disbursement, etc.)
    public ServiceResult<Void> creditAmount(int accountId, BigDecimal amount) {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid credit amount");

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Account must be active");

            boolean updated = accountDAO.addToBalance(accountId, amount);

            if (!updated)
                return ServiceResult.failure("Credit failed");

            return ServiceResult.success("Amount credited successfully", null);

        } catch (Exception e) {
            throw new AccountServiceException("Error while crediting amount");
        }
    }

    // DEBIT AMOUNT (EMI payment, etc.)
    public ServiceResult<Void> debitAmount(int accountId, BigDecimal amount) {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid debit amount");

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Account must be active");

            if (account.getBalance().compareTo(amount) < 0)
                return ServiceResult.failure("Insufficient balance");

            boolean updated = accountDAO.addToBalance(accountId, amount.negate());

            if (!updated)
                return ServiceResult.failure("Debit failed");

            return ServiceResult.success("Amount debited successfully", null);

        } catch (Exception e) {
            throw new AccountServiceException("Error while debiting amount");
        }
    }


    // 6️⃣ CLOSE ACCOUNT
    public ServiceResult<Void> closeAccount(int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() == AccountStatus.CLOSED)
                return ServiceResult.failure("Account already closed");

            boolean updated = accountDAO.updateAccountStatus(
                    accountId, AccountStatus.CLOSED);

            if (!updated)
                return ServiceResult.failure("Failed to close account");

            return ServiceResult.success("Account closed successfully", null);

        } catch (Exception e) {
            throw new AccountServiceException("Error while closing account");
        }
    }
}
