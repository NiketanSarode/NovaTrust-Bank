package dao;

import model.Account; 
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class AccountDAO {

    // CREATE ACCOUNT
    public boolean createAccount(Account account) {

        String sql = "INSERT INTO accounts " +
                "(user_id, account_number, account_type, balance) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, account.getUserId());
            ps.setString(2, account.getAccountNumber());

            // ✅ ENUM → STRING
            if (account.getAccountType() != null) {
                ps.setString(3, account.getAccountType().name());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            // ✅ BigDecimal (DB default allowed)
            if (account.getBalance() != null) {
                ps.setBigDecimal(4, account.getBalance());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET ACCOUNT BY ID
    public Account getAccountById(int accountId) {

        String sql = "SELECT * FROM accounts WHERE account_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapAccount(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ACCOUNT BY ACCOUNT NUMBER
    public Account getAccountByNumber(String accountNumber) {

        String sql = "SELECT * FROM accounts WHERE account_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accountNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapAccount(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL ACCOUNTS OF USER
    public List<Account> getAccountsByUserId(int userId) {

        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapAccount(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE BALANCE
    public boolean updateBalance(int accountId, BigDecimal balance) {

        String sql = "UPDATE accounts SET balance = ? WHERE account_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBigDecimal(1, balance);
            ps.setInt(2, accountId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE STATUS (ENUM SAFE)
    public boolean updateAccountStatus(int accountId, Account.AccountStatus status) {

        String sql = "UPDATE accounts SET status = ? WHERE account_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ps.setInt(2, accountId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // CHECK ACCOUNT NUMBER EXISTS
    public boolean isAccountNumberExists(String accountNumber) {

        String sql = "SELECT account_id FROM accounts WHERE account_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, accountNumber);
            return ps.executeQuery().next();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
 // ADD / SUBTRACT BALANCE (positive = credit, negative = debit)
    public boolean addToBalance(int accountId, BigDecimal amount) {

        String sql = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBigDecimal(1, amount);
            ps.setInt(2, accountId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → ACCOUNT (ENUM SAFE)
    private Account mapAccount(ResultSet rs) throws SQLException {

        Account account = new Account();

        account.setAccountId(rs.getInt("account_id"));
        account.setUserId(rs.getInt("user_id"));
        account.setAccountNumber(rs.getString("account_number"));

        // ✅ STRING → ENUM
        String type = rs.getString("account_type");
        if (type != null) {
            account.setAccountType(Account.AccountType.valueOf(type));
        }

        account.setBalance(rs.getBigDecimal("balance"));

        String status = rs.getString("status");
        if (status != null) {
            account.setStatus(Account.AccountStatus.valueOf(status));
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            account.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            account.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return account;
    }
}
