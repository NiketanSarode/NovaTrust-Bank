package model;

import java.math.BigDecimal; 
import java.time.LocalDateTime;

public class InsurancePlan {

    // ✅ ENUM (inside same class)
    public enum InsuranceType {
        HEALTH,
        LIFE,
        VEHICLE,
        TRAVEL,
        ACCIDENT
    }

    private Integer insuranceId;

    private String insuranceName;
    private InsuranceType insuranceType;   // ✅ enum

    private BigDecimal coverageAmount;
    private BigDecimal premiumAmount;

    private Integer tenureYears;

    private String description;

    private Boolean isActive;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ✅ No-argument constructor
    public InsurancePlan() {
    }

    // ✅ Parameterized constructor
    public InsurancePlan(Integer insuranceId, String insuranceName, InsuranceType insuranceType,
                         BigDecimal coverageAmount, BigDecimal premiumAmount,
                         Integer tenureYears, String description,
                         Boolean isActive, LocalDateTime createdAt,
                         LocalDateTime updatedAt) {

        this.insuranceId = insuranceId;
        this.insuranceName = insuranceName;
        this.insuranceType = insuranceType;
        this.coverageAmount = coverageAmount;
        this.premiumAmount = premiumAmount;
        this.tenureYears = tenureYears;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ✅ Getters & Setters

    public Integer getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(Integer insuranceId) {
        this.insuranceId = insuranceId;
    }

    public String getInsuranceName() {
        return insuranceName;
    }

    public void setInsuranceName(String insuranceName) {
        this.insuranceName = insuranceName;
    }

    public InsuranceType getInsuranceType() {
        return insuranceType;
    }

    public void setInsuranceType(InsuranceType insuranceType) {
        this.insuranceType = insuranceType;
    }

    public BigDecimal getCoverageAmount() {
        return coverageAmount;
    }

    public void setCoverageAmount(BigDecimal coverageAmount) {
        this.coverageAmount = coverageAmount;
    }

    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public Integer getTenureYears() {
        return tenureYears;
    }

    public void setTenureYears(Integer tenureYears) {
        this.tenureYears = tenureYears;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
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

    // ✅ Helpful for logs / debugging
    @Override
    public String toString() {
        return "InsurancePlan{" +
                "insuranceId=" + insuranceId +
                ", insuranceName='" + insuranceName + '\'' +
                ", insuranceType=" + insuranceType +
                ", coverageAmount=" + coverageAmount +
                ", premiumAmount=" + premiumAmount +
                ", isActive=" + isActive +
                '}';
    }
}

