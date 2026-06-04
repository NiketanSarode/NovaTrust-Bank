package services;

import dao.NotificationDAO;
import model.Notification;
import model.Notification.NotificationType;
import services.exception.NotificationServiceException;

import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    // 1️⃣ SEND NOTIFICATION (AUTO CREATE)
    public ServiceResult<Void> sendNotification(
            int accountId,
            Integer transactionId,
            String title,
            String message,
            NotificationType type) {

        if (title == null || title.isBlank())
            return ServiceResult.failure("Notification title cannot be empty");

        if (message == null || message.isBlank())
            return ServiceResult.failure("Notification message cannot be empty");

        try {
            Notification n = new Notification();
            n.setAccountId(accountId);
            n.setTransactionId(transactionId); // can be null
            n.setTitle(title);
            n.setMessage(message);
            n.setNotificationType(type);
            n.setIsRead(false);

            boolean created = notificationDAO.createNotification(n);

            if (!created)
                return ServiceResult.failure("Failed to send notification");

            return ServiceResult.success(
                    "Notification sent successfully", null);

        } catch (Exception e) {
            throw new NotificationServiceException(
                    "Error while sending notification", e);
        }
    }

    // 2️⃣ VIEW NOTIFICATIONS
    public ServiceResult<List<Notification>> viewNotifications(int accountId) {

        try {
            List<Notification> list =
                    notificationDAO.getNotificationsByAccountId(accountId);

            if (list.isEmpty())
                return ServiceResult.failure(
                        "No notifications available");

            return ServiceResult.success(
                    "Notifications fetched successfully",
                    list
            );

        } catch (Exception e) {
            throw new NotificationServiceException(
                    "Error while fetching notifications", e);
        }
    }

    // 3️⃣ MARK NOTIFICATION AS READ
    public ServiceResult<Void> markNotificationAsRead(int notificationId) {

        try {
            Notification n =
                    notificationDAO.getNotificationById(notificationId);

            if (n == null)
                return ServiceResult.failure(
                        "Notification not found");

            if (Boolean.TRUE.equals(n.getIsRead()))
                return ServiceResult.failure(
                        "Notification already marked as read");

            boolean updated =
                    notificationDAO.markAsRead(notificationId);

            if (!updated)
                return ServiceResult.failure(
                        "Failed to mark notification as read");

            return ServiceResult.success(
                    "Notification marked as read", null);

        } catch (Exception e) {
            throw new NotificationServiceException(
                    "Error while updating notification", e);
        }
    }
}
