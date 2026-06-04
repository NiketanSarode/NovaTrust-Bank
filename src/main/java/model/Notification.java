package model;

import java.time.LocalDateTime;



public class Notification {

    // ✅ ENUM (inside same class)
    public enum NotificationType {
        TRANSACTION,
        OFFER,
        SYSTEM
    }

    private Integer notificationId;

    private Integer accountId;
    private Integer transactionId;   // NULL allowed (OFFER / SYSTEM)

    private String title;
    private String message;

    private NotificationType notificationType;   // ✅ enum

    private Boolean isRead;

    private LocalDateTime createdAt;

    // ✅ No-argument constructor
    public Notification() {
    }

    // ✅ Parameterized constructor
    public Notification(Integer notificationId, Integer accountId,
                        Integer transactionId, String title,
                        String message, NotificationType notificationType,
                        Boolean isRead, LocalDateTime createdAt) {

        this.notificationId = notificationId;
        this.accountId = accountId;
        this.transactionId = transactionId;
        this.title = title;
        this.message = message;
        this.notificationType = notificationType;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    // ✅ Getters & Setters

    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getAccountId() {
        return accountId;
    }

    public void setAccountId(Integer accountId) {
        this.accountId = accountId;
    }

    public Integer getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Integer transactionId) {
        this.transactionId = transactionId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public NotificationType getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(NotificationType notificationType) {
        this.notificationType = notificationType;
    }

    public Boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
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
        return "Notification{" +
                "notificationId=" + notificationId +
                ", accountId=" + accountId +
                ", transactionId=" + transactionId +
                ", title='" + title + '\'' +
                ", notificationType=" + notificationType +
                ", isRead=" + isRead +
                '}';
    }
}


