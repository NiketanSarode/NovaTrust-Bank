package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Account {


	    // ✅ ENUMS (inside same class)
	    public enum AccountType {
	        SAVINGS,
	        CURRENT,
	    }

	    public enum AccountStatus {
	        ACTIVE,
	        BLOCKED,
	        CLOSED
	    }

	    private Integer accountId;
	    private Integer userId;

	    private String accountNumber;
	    private AccountType accountType;   // ✅ enum

	    private BigDecimal balance;

	    private AccountStatus status;       // ✅ enum

	    private LocalDateTime createdAt;
	    private LocalDateTime updatedAt;

	    // ✅ No-argument constructor
	    public Account() {
	    }

	    // ✅ Parameterized constructor
	    public Account(Integer accountId, Integer userId, String accountNumber,
	                   AccountType accountType, BigDecimal balance, AccountStatus status,
	                   LocalDateTime createdAt, LocalDateTime updatedAt) {

	        this.accountId = accountId;
	        this.userId = userId;
	        this.accountNumber = accountNumber;
	        this.accountType = accountType;
	        this.balance = balance;
	        this.status = status;
	        this.createdAt = createdAt;
	        this.updatedAt = updatedAt;
	    }

	    // ✅ Getters & Setters

	    public Integer getAccountId() {
	        return accountId;
	    }

	    public void setAccountId(Integer accountId) {
	        this.accountId = accountId;
	    }

	    public Integer getUserId() {
	        return userId;
	    }

	    public void setUserId(Integer userId) {
	        this.userId = userId;
	    }

	    public String getAccountNumber() {
	        return accountNumber;
	    }

	    public void setAccountNumber(String accountNumber) {
	        this.accountNumber = accountNumber;
	    }

	    public AccountType getAccountType() {
	        return accountType;
	    }

	    public void setAccountType(AccountType accountType) {
	        this.accountType = accountType;
	    }

	    public BigDecimal getBalance() {
	        return balance;
	    }

	    public void setBalance(BigDecimal balance) {
	        this.balance = balance;
	    }

	    public AccountStatus getStatus() {
	        return status;
	    }

	    public void setStatus(AccountStatus status) {
	        this.status = status;
	    }

	    public LocalDateTime getCreatedAt() {
	        return createdAt;
	    }

	    public void setCreatedAt(LocalDateTime createdAt) {
	        this.createdAt = createdAt;
	    }

	    public LocalDateTime getUpdatedAt() {
	        return updatedAt;
	    }

	    public void setUpdatedAt(LocalDateTime updatedAt) {
	        this.updatedAt = updatedAt;
	    }

	    @Override
	    public String toString() {
	        return "Account{" +
	                "accountId=" + accountId +
	                ", userId=" + userId +
	                ", accountNumber='" + accountNumber + '\'' +
	                ", accountType=" + accountType +
	                ", balance=" + balance +
	                ", status=" + status +
	                '}';
	    }
	}
