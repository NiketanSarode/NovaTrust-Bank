package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class UserInsurance {

    // ✅ ENUM (inside same class)
    public enum InsuranceStatus {
        ACTIVE,
        EXPIRED,
        CANCELLED
    }

    private Integer userInsuranceId;

    private Integer userId;
    private Integer insuranceId;

    private String policyNumber;

    private LocalDate startDate;
    private LocalDate endDate;

    private BigDecimal premiumAmount;

    private InsuranceStatus insuranceStatus;   // ✅ enum

    private LocalDateTime createdAt;

    // ✅ No-argument constructor
    public UserInsurance() {
    }

    // ✅ Parameterized constructor
    public UserInsurance(Integer userInsuranceId, Integer userId, Integer insuranceId,
                         String policyNumber, LocalDate startDate, LocalDate endDate,
                         BigDecimal premiumAmount, InsuranceStatus insuranceStatus,
                         LocalDateTime createdAt) {

        this.userInsuranceId = userInsuranceId;
        this.userId = userId;
        this.insuranceId = insuranceId;
        this.policyNumber = policyNumber;
        this.startDate = startDate;
        this.endDate = endDate;
        this.premiumAmount = premiumAmount;
        this.insuranceStatus = insuranceStatus;
        this.createdAt = createdAt;
    }

    // ✅ Getters & Setters

    public Integer getUserInsuranceId() {
        return userInsuranceId;
    }

    public void setUserInsuranceId(Integer userInsuranceId) {
        this.userInsuranceId = userInsuranceId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(Integer insuranceId) {
        this.insuranceId = insuranceId;
    }

    public String getPolicyNumber() {
        return policyNumber;
    }

    public void setPolicyNumber(String policyNumber) {
        this.policyNumber = policyNumber;
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

    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public InsuranceStatus getInsuranceStatus() {
        return insuranceStatus;
    }

    public void setInsuranceStatus(InsuranceStatus insuranceStatus) {
        this.insuranceStatus = insuranceStatus;
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
        return "UserInsurance{" +
                "userInsuranceId=" + userInsuranceId +
                ", userId=" + userId +
                ", insuranceId=" + insuranceId +
                ", policyNumber='" + policyNumber + '\'' +
                ", insuranceStatus=" + insuranceStatus +
                '}';
    }
}
