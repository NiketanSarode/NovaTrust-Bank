package dao;

import model.UserInsurance;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserInsuranceDAO {

    // CREATE USER INSURANCE
    public boolean createUserInsurance(UserInsurance ui) {

        String sql = "INSERT INTO user_insurance " +
                "(user_id, insurance_id, policy_number, start_date, end_date, " +
                "premium_amount, insurance_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ui.getUserId());
            ps.setInt(2, ui.getInsuranceId());
            ps.setString(3, ui.getPolicyNumber());

            // start_date
            if (ui.getStartDate() != null) {
                ps.setDate(4, Date.valueOf(ui.getStartDate()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            // end_date
            if (ui.getEndDate() != null) {
                ps.setDate(5, Date.valueOf(ui.getEndDate()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            // premium_amount
            if (ui.getPremiumAmount() != null) {
                ps.setBigDecimal(6, ui.getPremiumAmount());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }

            // insurance_status (DB default allowed)
            if (ui.getInsuranceStatus() != null) {
                ps.setString(7, ui.getInsuranceStatus().name());
            } else {
                ps.setNull(7, Types.VARCHAR);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET USER INSURANCE BY ID
    public UserInsurance getUserInsuranceById(int userInsuranceId) {

        String sql = "SELECT * FROM user_insurance WHERE user_insurance_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userInsuranceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUserInsurance(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL INSURANCE OF A USER
    public List<UserInsurance> getUserInsuranceByUserId(int userId) {

        List<UserInsurance> list = new ArrayList<>();

        String sql = "SELECT * FROM user_insurance " +
                "WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapUserInsurance(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE INSURANCE STATUS (ENUM SAFE)
    public boolean updateInsuranceStatus(
            int userInsuranceId,
            UserInsurance.InsuranceStatus status) {

        String sql = "UPDATE user_insurance SET insurance_status = ? WHERE user_insurance_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ps.setInt(2, userInsuranceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → USER INSURANCE (ENUM SAFE)
    private UserInsurance mapUserInsurance(ResultSet rs) throws SQLException {

        UserInsurance ui = new UserInsurance();

        ui.setUserInsuranceId(rs.getInt("user_insurance_id"));
        ui.setUserId(rs.getInt("user_id"));
        ui.setInsuranceId(rs.getInt("insurance_id"));
        ui.setPolicyNumber(rs.getString("policy_number"));

        Date start = rs.getDate("start_date");
        if (start != null) {
            ui.setStartDate(start.toLocalDate());
        }

        Date end = rs.getDate("end_date");
        if (end != null) {
            ui.setEndDate(end.toLocalDate());
        }

        ui.setPremiumAmount(rs.getBigDecimal("premium_amount"));

        String status = rs.getString("insurance_status");
        if (status != null) {
            ui.setInsuranceStatus(
                    UserInsurance.InsuranceStatus.valueOf(status)
            );
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            ui.setCreatedAt(createdAt.toLocalDateTime());
        }

        return ui;
    }
}
