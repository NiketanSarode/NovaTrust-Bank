package dao;

import model.User; 
import util.DBConnection;

import java.sql.*;
import java.sql.Types;

public class UserDAO {

    // REGISTER USER
    public boolean registerUser(User user) {

        String sql = "INSERT INTO users " +
                "(full_name, email, phone, password, dob, gender, address) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());

            if (user.getDob() != null) {
                ps.setDate(5, Date.valueOf(user.getDob()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            // ✅ ENUM → STRING
            if (user.getGender() != null) {
                ps.setString(6, user.getGender().name());
            } else {
                ps.setNull(6, Types.VARCHAR);
            }

            ps.setString(7, user.getAddress());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e); // 🔥 ADD THIS LINE
        }
       
    }

    // LOGIN USER
    public User loginUser(String email, String password) {

        String sql = "SELECT * FROM users " +
                     "WHERE email = ? AND password = ? AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET USER BY EMAIL
    public User getUserByEmail(String email) {

        String sql = "SELECT * FROM users WHERE email = ? AND status != 'DELETED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET USER BY ID
    public User getUserById(int userId) {

        String sql = "SELECT * FROM users WHERE user_id = ? AND status != 'DELETED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // CHECK EMAIL EXISTS
    public boolean isEmailExists(String email) {

        String sql = "SELECT 1 FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // ✅ record hai = exists
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false; // error means treat as not exists
    }


    // CHECK PHONE EXISTS
    public boolean isPhoneExists(String phone) {

        String sql = "SELECT 1 FROM users WHERE phone = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // ✅ record hai = exists
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    // UPDATE PROFILE
    public boolean updateUserProfile(User user) {

        String sql = "UPDATE users SET full_name=?, dob=?, gender=?, address=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());

            if (user.getDob() != null) {
                ps.setDate(2, Date.valueOf(user.getDob()));
            } else {
                ps.setNull(2, Types.DATE);
            }

            // ✅ ENUM handling
            if (user.getGender() != null) {
                ps.setString(3, user.getGender().name());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE PASSWORD
    public boolean updatePassword(int userId, String password) {

        String sql = "UPDATE users SET password=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, password);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE VERIFICATION
    public boolean updateVerificationStatus(int userId, boolean verified) {

        String sql = "UPDATE users SET is_verified=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, verified);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // UPDATE STATUS (ENUM)
    public boolean updateUserStatus(int userId, User.Status status) {

        String sql = "UPDATE users SET status=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → USER (ENUM SAFE)
    private User mapUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));

        if (rs.getDate("dob") != null) {
            user.setDob(rs.getDate("dob").toLocalDate());
        }

        // ✅ STRING → ENUM
        String gender = rs.getString("gender");
        if (gender != null) {
            user.setGender(User.Gender.valueOf(gender));
        }

        String status = rs.getString("status");
        if (status != null) {
            user.setStatus(User.Status.valueOf(status));
        }

        user.setAddress(rs.getString("address"));
        user.setIsVerified(rs.getBoolean("is_verified"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return user;
    }
}
