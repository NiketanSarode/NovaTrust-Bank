package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaction {

    // ✅ ENUMS (inside same class)
    public enum TransactionType {
        DEBIT,
        CREDIT,
        TRANSFER
    }

    public enum TransactionStatus {
        PENDING,
        SUCCESS,
        FAILED
    }

    private Integer transactionId;

    private Integer senderAccountId;     // NULL allowed (CREDIT case)
    private Integer receiverAccountId;   // NULL allowed (DEBIT case)

    private BigDecimal amount;

    private TransactionType transactionType;      // ✅ enum
    private TransactionStatus transactionStatus;  // ✅ enum

    private String referenceId;
    private String description;

    private LocalDateTime transactionTime;

    // ✅ No-argument constructor
    public Transaction() {
    }

    // ✅ Parameterized constructor
    public Transaction(Integer transactionId, Integer senderAccountId,
                       Integer receiverAccountId, BigDecimal amount,
                       TransactionType transactionType, TransactionStatus transactionStatus,
                       String referenceId, String description,
                       LocalDateTime transactionTime) {

        this.transactionId = transactionId;
        this.senderAccountId = senderAccountId;
        this.receiverAccountId = receiverAccountId;
        this.amount = amount;
        this.transactionType = transactionType;
        this.transactionStatus = transactionStatus;
        this.referenceId = referenceId;
        this.description = description;
        this.transactionTime = transactionTime;
    }

    // ✅ Getters & Setters

    public Integer getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Integer transactionId) {
        this.transactionId = transactionId;
    }

    public Integer getSenderAccountId() {
        return senderAccountId;
    }

    public void setSenderAccountId(Integer senderAccountId) {
        this.senderAccountId = senderAccountId;
    }

    public Integer getReceiverAccountId() {
        return receiverAccountId;
    }

    public void setReceiverAccountId(Integer receiverAccountId) {
        this.receiverAccountId = receiverAccountId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public TransactionStatus getTransactionStatus() {
        return transactionStatus;
    }

    public void setTransactionStatus(TransactionStatus transactionStatus) {
        this.transactionStatus = transactionStatus;
    }

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getTransactionTime() {
        return transactionTime;
    }

    public void setTransactionTime(LocalDateTime transactionTime) {
        this.transactionTime = transactionTime;
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "transactionId=" + transactionId +
                ", senderAccountId=" + senderAccountId +
                ", receiverAccountId=" + receiverAccountId +
                ", amount=" + amount +
                ", transactionType=" + transactionType +
                ", transactionStatus=" + transactionStatus +
                '}';
    }
}

