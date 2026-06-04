package model;

import java.time.LocalDateTime;

public class Service {

    private Integer serviceId;

    private String serviceName;   // Display name (e.g., Loans, Insurance)
    private String serviceKey;    // Backend key (e.g., LOAN, INSURANCE)

    private String description;

    private String icon;          // UI icon class (FontAwesome / Material)
    private String redirectUrl;   // JSP / route path

    private Boolean isActive;     // Dashboard show/hide control

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ✅ No-argument constructor
    public Service() {
    }

    // ✅ Parameterized constructor
    public Service(Integer serviceId, String serviceName, String serviceKey,
                   String description, String icon, String redirectUrl,
                   Boolean isActive, LocalDateTime createdAt,
                   LocalDateTime updatedAt) {

        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceKey = serviceKey;
        this.description = description;
        this.icon = icon;
        this.redirectUrl = redirectUrl;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ✅ Getters & Setters

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getServiceKey() {
        return serviceKey;
    }

    public void setServiceKey(String serviceKey) {
        this.serviceKey = serviceKey;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
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
        return "Service{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", serviceKey='" + serviceKey + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}

