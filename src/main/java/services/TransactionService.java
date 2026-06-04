package services;

import dao.AccountDAO;
import dao.TransactionDAO;
import model.Account;
import model.Transaction;
import model.Account.AccountStatus;
import model.Transaction.TransactionStatus;
import model.Transaction.TransactionType;
import services.exception.TransactionServiceException;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class TransactionService {

    private final TransactionDAO transactionDAO;
    private final AccountDAO accountDAO;

    public TransactionService() {
        this.transactionDAO = new TransactionDAO();
        this.accountDAO = new AccountDAO();
    }

    // 1️⃣ VALIDATE BENEFICIARY
    public ServiceResult<Void> validateBeneficiary(
            int senderAccountId,
            int receiverAccountId) {

        if (senderAccountId == receiverAccountId)
            return ServiceResult.failure("Sender and receiver accounts cannot be same");

        try {
            Account sender = accountDAO.getAccountById(senderAccountId);
            Account receiver = accountDAO.getAccountById(receiverAccountId);

            if (sender == null || receiver == null)
                return ServiceResult.failure("Invalid account details");

            if (sender.getStatus() != AccountStatus.ACTIVE ||
                receiver.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Both accounts must be active");

            if (!sender.getUserId().equals(receiver.getUserId()))
                return ServiceResult.failure("Beneficiary must belong to same user");

            return ServiceResult.success("Beneficiary validated successfully", null);

        } catch (Exception e) {
            throw new TransactionServiceException("Error while validating beneficiary", e);
        }
    }

    // 2️⃣ TRANSFER MONEY (DEBIT + CREDIT)
    public ServiceResult<Void> transferMoney(
            int senderAccountId,
            int receiverAccountId,
            BigDecimal amount) {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid transfer amount");

        try {
            // validate beneficiary
            ServiceResult<Void> validation =
                    validateBeneficiary(senderAccountId, receiverAccountId);

            if (!validation.isSuccess())
                return validation;

            Account sender = accountDAO.getAccountById(senderAccountId);
            Account receiver = accountDAO.getAccountById(receiverAccountId);

            // insufficient balance check
            if (sender.getBalance().compareTo(amount) < 0)
                return ServiceResult.failure("Insufficient balance");

            // debit sender
            BigDecimal senderNewBalance =
                    sender.getBalance().subtract(amount);

            boolean debitDone =
                    accountDAO.updateBalance(senderAccountId, senderNewBalance);

            if (!debitDone)
                return ServiceResult.failure("Debit failed");

            // credit receiver
            BigDecimal receiverNewBalance =
                    receiver.getBalance().add(amount);

            boolean creditDone =
                    accountDAO.updateBalance(receiverAccountId, receiverNewBalance);

            if (!creditDone)
                return ServiceResult.failure("Credit failed");

            // create transaction entry
            Transaction tx = new Transaction();
            tx.setSenderAccountId(senderAccountId);
            tx.setReceiverAccountId(receiverAccountId);
            tx.setAmount(amount);
            tx.setTransactionType(TransactionType.TRANSFER);
            tx.setTransactionStatus(TransactionStatus.SUCCESS);
            tx.setReferenceId(UUID.randomUUID().toString());
            tx.setDescription("Account to account transfer");
            tx.setTransactionTime(LocalDateTime.now());

            transactionDAO.createTransaction(tx);

            return ServiceResult.success("Money transferred successfully", null);

        } catch (Exception e) {
            throw new TransactionServiceException("Error during money transfer", e);
        }
    }

    // 3️⃣ RECEIVE MONEY (CREDIT ONLY)
    public ServiceResult<Void> receiveMoney(
            int receiverAccountId,
            BigDecimal amount) {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid amount");

        try {
            Account receiver = accountDAO.getAccountById(receiverAccountId);

            if (receiver == null)
                return ServiceResult.failure("Account not found");

            if (receiver.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Account is not active");

            BigDecimal newBalance =
                    receiver.getBalance().add(amount);

            boolean updated =
                    accountDAO.updateBalance(receiverAccountId, newBalance);

            if (!updated)
                return ServiceResult.failure("Failed to receive money");

            Transaction tx = new Transaction();
            tx.setSenderAccountId(null);
            tx.setReceiverAccountId(receiverAccountId);
            tx.setAmount(amount);
            tx.setTransactionType(TransactionType.CREDIT);
            tx.setTransactionStatus(TransactionStatus.SUCCESS);
            tx.setReferenceId(UUID.randomUUID().toString());
            tx.setDescription("Amount credited");
            tx.setTransactionTime(LocalDateTime.now());

            transactionDAO.createTransaction(tx);

            return ServiceResult.success("Money received successfully", null);

        } catch (Exception e) {
            throw new TransactionServiceException("Error while receiving money", e);
        }
    }

    // 4️⃣ GET TRANSACTION HISTORY
    public ServiceResult<List<Transaction>> getTransactionHistory(
            int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            List<Transaction> list =
                    transactionDAO.getTransactionsByAccountId(accountId);

            return ServiceResult.success("Transaction history fetched", list);

        } catch (Exception e) {
            throw new TransactionServiceException(
                    "Error while fetching transaction history", e);
        }
    }
}
