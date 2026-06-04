package dao;

import model.Notification;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    // CREATE NOTIFICATION
    public boolean createNotification(Notification n) {

        String sql = "INSERT INTO notifications " +
                "(account_id, transaction_id, title, message, notification_type, is_read) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, n.getAccountId());

            // transaction_id (nullable)
            if (n.getTransactionId() != null) {
                ps.setInt(2, n.getTransactionId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setString(3, n.getTitle());
            ps.setString(4, n.getMessage());

            // ENUM → STRING (DB default allowed)
            if (n.getNotificationType() != null) {
                ps.setString(5, n.getNotificationType().name());
            } else {
                ps.setNull(5, Types.VARCHAR);
            }

            // is_read (DB default allowed)
            if (n.getIsRead() != null) {
                ps.setBoolean(6, n.getIsRead());
            } else {
                ps.setNull(6, Types.BOOLEAN);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET NOTIFICATION BY ID
    public Notification getNotificationById(int notificationId) {

        String sql = "SELECT * FROM notifications WHERE notification_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapNotification(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL NOTIFICATIONS OF ACCOUNT
    public List<Notification> getNotificationsByAccountId(int accountId) {

        List<Notification> list = new ArrayList<>();

        String sql = "SELECT * FROM notifications " +
                "WHERE account_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapNotification(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // MARK AS READ
    public boolean markAsRead(int notificationId) {

        String sql = "UPDATE notifications SET is_read = true WHERE notification_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE NOTIFICATION
    public boolean deleteNotification(int notificationId) {

        String sql = "DELETE FROM notifications WHERE notification_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → NOTIFICATION (ENUM SAFE)
    private Notification mapNotification(ResultSet rs) throws SQLException {

        Notification n = new Notification();

        n.setNotificationId(rs.getInt("notification_id"));
        n.setAccountId(rs.getInt("account_id"));

        Integer txId = rs.getObject("transaction_id", Integer.class);
        n.setTransactionId(txId);

        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));

        String type = rs.getString("notification_type");
        if (type != null) {
            n.setNotificationType(Notification.NotificationType.valueOf(type));
        }

        n.setIsRead(rs.getBoolean("is_read"));

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            n.setCreatedAt(ts.toLocalDateTime());
        }

        return n;
    }
}
