package dao;

import model.InsurancePlan;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InsurancePlanDAO {

    // CREATE INSURANCE PLAN
    public boolean createInsurancePlan(InsurancePlan plan) {

        String sql = "INSERT INTO insurance_plans " +
                "(insurance_name, insurance_type, coverage_amount, premium_amount, " +
                "tenure_years, description, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, plan.getInsuranceName());

            // ENUM → STRING
            if (plan.getInsuranceType() != null) {
                ps.setString(2, plan.getInsuranceType().name());
            } else {
                ps.setNull(2, Types.VARCHAR);
            }

            // coverage_amount
            if (plan.getCoverageAmount() != null) {
                ps.setBigDecimal(3, plan.getCoverageAmount());
            } else {
                ps.setNull(3, Types.DECIMAL);
            }

            // premium_amount
            if (plan.getPremiumAmount() != null) {
                ps.setBigDecimal(4, plan.getPremiumAmount());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }

            // tenure_years
            if (plan.getTenureYears() != null) {
                ps.setInt(5, plan.getTenureYears());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            ps.setString(6, plan.getDescription());

            // is_active (DB default allowed)
            if (plan.getIsActive() != null) {
                ps.setBoolean(7, plan.getIsActive());
            } else {
                ps.setNull(7, Types.BOOLEAN);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET INSURANCE PLAN BY ID
    public InsurancePlan getInsurancePlanById(int insuranceId) {

        String sql = "SELECT * FROM insurance_plans WHERE insurance_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, insuranceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapInsurancePlan(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL ACTIVE INSURANCE PLANS
    public List<InsurancePlan> getActiveInsurancePlans() {

        List<InsurancePlan> list = new ArrayList<>();

        String sql = "SELECT * FROM insurance_plans " +
                "WHERE is_active = true ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapInsurancePlan(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE PLAN STATUS
    public boolean updateInsuranceStatus(int insuranceId, boolean active) {

        String sql = "UPDATE insurance_plans SET is_active = ? WHERE insurance_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, active);
            ps.setInt(2, insuranceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → INSURANCE PLAN (ENUM SAFE)
    private InsurancePlan mapInsurancePlan(ResultSet rs) throws SQLException {

        InsurancePlan plan = new InsurancePlan();

        plan.setInsuranceId(rs.getInt("insurance_id"));
        plan.setInsuranceName(rs.getString("insurance_name"));

        String type = rs.getString("insurance_type");
        if (type != null) {
            plan.setInsuranceType(InsurancePlan.InsuranceType.valueOf(type));
        }

        plan.setCoverageAmount(rs.getBigDecimal("coverage_amount"));
        plan.setPremiumAmount(rs.getBigDecimal("premium_amount"));
        plan.setTenureYears(rs.getInt("tenure_years"));
        plan.setDescription(rs.getString("description"));
        plan.setIsActive(rs.getBoolean("is_active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            plan.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            plan.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return plan;
    }
}
