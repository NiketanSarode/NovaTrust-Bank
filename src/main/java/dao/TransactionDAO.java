package dao;

import model.Transaction;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class TransactionDAO {

    // CREATE TRANSACTION
    public boolean createTransaction(Transaction tx) {

        String sql = "INSERT INTO transactions " +
                "(sender_account_id, receiver_account_id, amount, transaction_type, " +
                "transaction_status, reference_id, description) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // sender_account_id (nullable)
            if (tx.getSenderAccountId() != null) {
                ps.setInt(1, tx.getSenderAccountId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            // receiver_account_id (nullable)
            if (tx.getReceiverAccountId() != null) {
                ps.setInt(2, tx.getReceiverAccountId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            // amount
            if (tx.getAmount() != null) {
                ps.setBigDecimal(3, tx.getAmount());
            } else {
                throw new SQLException("Transaction amount cannot be null");
            }

            // ENUM → STRING
            if (tx.getTransactionType() != null) {
                ps.setString(4, tx.getTransactionType().name());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }

            // status (DB default allowed)
            if (tx.getTransactionStatus() != null) {
                ps.setString(5, tx.getTransactionStatus().name());
            } else {
                ps.setNull(5, Types.VARCHAR);
            }

            ps.setString(6, tx.getReferenceId());
            ps.setString(7, tx.getDescription());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET TRANSACTION BY ID
    public Transaction getTransactionById(int transactionId) {

        String sql = "SELECT * FROM transactions WHERE transaction_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, transactionId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapTransaction(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL TRANSACTIONS OF AN ACCOUNT
    public List<Transaction> getTransactionsByAccountId(int accountId) {

        List<Transaction> list = new ArrayList<>();

        String sql = "SELECT * FROM transactions " +
                "WHERE sender_account_id = ? OR receiver_account_id = ? " +
                "ORDER BY transaction_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ps.setInt(2, accountId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapTransaction(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE TRANSACTION STATUS (ENUM SAFE)
    public boolean updateTransactionStatus(
            int transactionId,
            Transaction.TransactionStatus status) {

        String sql = "UPDATE transactions SET transaction_status = ? WHERE transaction_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ps.setInt(2, transactionId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → TRANSACTION (ENUM SAFE)
    private Transaction mapTransaction(ResultSet rs) throws SQLException {

        Transaction tx = new Transaction();

        tx.setTransactionId(rs.getInt("transaction_id"));

        Integer senderId = rs.getObject("sender_account_id", Integer.class);
        tx.setSenderAccountId(senderId);

        Integer receiverId = rs.getObject("receiver_account_id", Integer.class);
        tx.setReceiverAccountId(receiverId);

        tx.setAmount(rs.getBigDecimal("amount"));

        String type = rs.getString("transaction_type");
        if (type != null) {
            tx.setTransactionType(Transaction.TransactionType.valueOf(type));
        }

        String status = rs.getString("transaction_status");
        if (status != null) {
            tx.setTransactionStatus(Transaction.TransactionStatus.valueOf(status));
        }

        tx.setReferenceId(rs.getString("reference_id"));
        tx.setDescription(rs.getString("description"));

        Timestamp ts = rs.getTimestamp("transaction_time");
        if (ts != null) {
            tx.setTransactionTime(ts.toLocalDateTime());
        }

        return tx;
    }
}
