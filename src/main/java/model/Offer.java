package model;

import java.math.BigDecimal; 
import java.time.LocalDate;
import java.time.LocalDateTime;


public class Offer {

    // ✅ ENUM (inside same class)
    public enum OfferType {
        CASHBACK,
        DISCOUNT,
        INTEREST,
        VOUCHER
    }

    private Integer offerId;

    private String offerTitle;
    private String offerDescription;

    private OfferType offerType;   // ✅ enum

    private BigDecimal minAmount;
    private BigDecimal maxAmount;

    private LocalDate startDate;
    private LocalDate endDate;

    private Boolean isActive;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ✅ No-argument constructor
    public Offer() {
    }

    // ✅ Parameterized constructor
    public Offer(Integer offerId, String offerTitle, String offerDescription,
                 OfferType offerType, BigDecimal minAmount, BigDecimal maxAmount,
                 LocalDate startDate, LocalDate endDate, Boolean isActive,
                 LocalDateTime createdAt, LocalDateTime updatedAt) {

        this.offerId = offerId;
        this.offerTitle = offerTitle;
        this.offerDescription = offerDescription;
        this.offerType = offerType;
        this.minAmount = minAmount;
        this.maxAmount = maxAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ✅ Getters & Setters

    public Integer getOfferId() {
        return offerId;
    }

    public void setOfferId(Integer offerId) {
        this.offerId = offerId;
    }

    public String getOfferTitle() {
        return offerTitle;
    }

    public void setOfferTitle(String offerTitle) {
        this.offerTitle = offerTitle;
    }

    public String getOfferDescription() {
        return offerDescription;
    }

    public void setOfferDescription(String offerDescription) {
        this.offerDescription = offerDescription;
    }

    public OfferType getOfferType() {
        return offerType;
    }

    public void setOfferType(OfferType offerType) {
        this.offerType = offerType;
    }

    public BigDecimal getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(BigDecimal minAmount) {
        this.minAmount = minAmount;
    }

    public BigDecimal getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(BigDecimal maxAmount) {
        this.maxAmount = maxAmount;
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
        return "Offer{" +
                "offerId=" + offerId +
                ", offerTitle='" + offerTitle + '\'' +
                ", offerType=" + offerType +
                ", isActive=" + isActive +
                '}';
    }
}


