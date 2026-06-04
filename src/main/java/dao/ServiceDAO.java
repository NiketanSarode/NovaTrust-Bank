package dao;

import model.Service;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    // CREATE SERVICE
    public boolean createService(Service s) {

        String sql = "INSERT INTO services " +
                "(service_name, service_key, description, icon, redirect_url, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getServiceName());
            ps.setString(2, s.getServiceKey());
            ps.setString(3, s.getDescription());

            // icon (nullable)
            if (s.getIcon() != null) {
                ps.setString(4, s.getIcon());
            } else {
                ps.setNull(4, Types.VARCHAR);
            }

            // redirect_url (nullable)
            if (s.getRedirectUrl() != null) {
                ps.setString(5, s.getRedirectUrl());
            } else {
                ps.setNull(5, Types.VARCHAR);
            }

            // is_active (DB default allowed)
            if (s.getIsActive() != null) {
                ps.setBoolean(6, s.getIsActive());
            } else {
                ps.setNull(6, Types.BOOLEAN);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET SERVICE BY ID
    public Service getServiceById(int serviceId) {

        String sql = "SELECT * FROM services WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapService(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET SERVICE BY KEY
    public Service getServiceByKey(String serviceKey) {

        String sql = "SELECT * FROM services WHERE service_key = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, serviceKey);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapService(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL ACTIVE SERVICES
    public List<Service> getActiveServices() {

        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services " +
                "WHERE is_active = true ORDER BY service_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapService(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE SERVICE STATUS
    public boolean updateServiceStatus(int serviceId, boolean active) {

        String sql = "UPDATE services SET is_active = ? WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, active);
            ps.setInt(2, serviceId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → SERVICE
    private Service mapService(ResultSet rs) throws SQLException {

        Service s = new Service();

        s.setServiceId(rs.getInt("service_id"));
        s.setServiceName(rs.getString("service_name"));
        s.setServiceKey(rs.getString("service_key"));
        s.setDescription(rs.getString("description"));
        s.setIcon(rs.getString("icon"));
        s.setRedirectUrl(rs.getString("redirect_url"));
        s.setIsActive(rs.getBoolean("is_active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            s.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            s.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return s;
    }
}
