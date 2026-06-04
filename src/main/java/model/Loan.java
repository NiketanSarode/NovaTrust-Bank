package model;

import java.math.BigDecimal; 
import java.time.LocalDate;
import java.time.LocalDateTime;


public class Loan {

    // ✅ ENUM (inside same class)
    public enum LoanStatus {
        APPLIED,
        APPROVED,
        REJECTED,
        ACTIVE,
        CLOSED
    }

    private Integer loanId;

    private Integer userId;
    private Integer accountId;

    private BigDecimal loanAmount;
    private BigDecimal interestRate;

    private Integer tenureMonths;

    private BigDecimal monthlyEmi;

    private LoanStatus loanStatus;   // ✅ enum

    private LocalDate startDate;
    private LocalDate endDate;

    private LocalDateTime createdAt;

    // ✅ No-argument constructor
    public Loan() {
    }

    // ✅ Parameterized constructor
    public Loan(Integer loanId, Integer userId, Integer accountId,
                BigDecimal loanAmount, BigDecimal interestRate,
                Integer tenureMonths, BigDecimal monthlyEmi,
                LoanStatus loanStatus, LocalDate startDate,
                LocalDate endDate, LocalDateTime createdAt) {

        this.loanId = loanId;
        this.userId = userId;
        this.accountId = accountId;
        this.loanAmount = loanAmount;
        this.interestRate = interestRate;
        this.tenureMonths = tenureMonths;
        this.monthlyEmi = monthlyEmi;
        this.loanStatus = loanStatus;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdAt = createdAt;
    }

    // ✅ Getters & Setters

    public Integer getLoanId() {
        return loanId;
    }

    public void setLoanId(Integer loanId) {
        this.loanId = loanId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getAccountId() {
        return accountId;
    }

    public void setAccountId(Integer accountId) {
        this.accountId = accountId;
    }

    public BigDecimal getLoanAmount() {
        return loanAmount;
    }

    public void setLoanAmount(BigDecimal loanAmount) {
        this.loanAmount = loanAmount;
    }

    public BigDecimal getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(BigDecimal interestRate) {
        this.interestRate = interestRate;
    }

    public Integer getTenureMonths() {
        return tenureMonths;
    }

    public void setTenureMonths(Integer tenureMonths) {
        this.tenureMonths = tenureMonths;
    }

    public BigDecimal getMonthlyEmi() {
        return monthlyEmi;
    }

    public void setMonthlyEmi(BigDecimal monthlyEmi) {
        this.monthlyEmi = monthlyEmi;
    }

    public LoanStatus getLoanStatus() {
        return loanStatus;
    }

    public void setLoanStatus(LoanStatus loanStatus) {
        this.loanStatus = loanStatus;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // ✅ Helpful for logs / debugging
    @Override
    public String toString() {
        return "Loan{" +
                "loanId=" + loanId +
                ", userId=" + userId +
                ", accountId=" + accountId +
                ", loanAmount=" + loanAmount +
                ", interestRate=" + interestRate +
                ", tenureMonths=" + tenureMonths +
                ", loanStatus=" + loanStatus +
                '}';
    }
}


