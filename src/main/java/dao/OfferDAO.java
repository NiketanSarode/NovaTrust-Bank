package dao;

import model.Offer;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OfferDAO {

    // CREATE OFFER
    public boolean createOffer(Offer offer) {

        String sql = "INSERT INTO offers " +
                "(offer_title, offer_description, offer_type, min_amount, max_amount, " +
                "start_date, end_date, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, offer.getOfferTitle());
            ps.setString(2, offer.getOfferDescription());

            // ENUM → STRING
            if (offer.getOfferType() != null) {
                ps.setString(3, offer.getOfferType().name());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            // min_amount
            if (offer.getMinAmount() != null) {
                ps.setBigDecimal(4, offer.getMinAmount());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }

            // max_amount
            if (offer.getMaxAmount() != null) {
                ps.setBigDecimal(5, offer.getMaxAmount());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }

            // start_date
            if (offer.getStartDate() != null) {
                ps.setDate(6, Date.valueOf(offer.getStartDate()));
            } else {
                ps.setNull(6, Types.DATE);
            }

            // end_date
            if (offer.getEndDate() != null) {
                ps.setDate(7, Date.valueOf(offer.getEndDate()));
            } else {
                ps.setNull(7, Types.DATE);
            }

            // is_active (DB default allowed)
            if (offer.getIsActive() != null) {
                ps.setBoolean(8, offer.getIsActive());
            } else {
                ps.setNull(8, Types.BOOLEAN);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET OFFER BY ID
    public Offer getOfferById(int offerId) {

        String sql = "SELECT * FROM offers WHERE offer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapOffer(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL ACTIVE OFFERS
    public List<Offer> getActiveOffers() {

        List<Offer> list = new ArrayList<>();

        String sql = "SELECT * FROM offers " +
                "WHERE is_active = true ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapOffer(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE OFFER STATUS
    public boolean updateOfferStatus(int offerId, boolean active) {

        String sql = "UPDATE offers SET is_active = ? WHERE offer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, active);
            ps.setInt(2, offerId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // RESULTSET → OFFER (ENUM SAFE)
    private Offer mapOffer(ResultSet rs) throws SQLException {

        Offer offer = new Offer();

        offer.setOfferId(rs.getInt("offer_id"));
        offer.setOfferTitle(rs.getString("offer_title"));
        offer.setOfferDescription(rs.getString("offer_description"));

        String type = rs.getString("offer_type");
        if (type != null) {
            offer.setOfferType(Offer.OfferType.valueOf(type));
        }

        offer.setMinAmount(rs.getBigDecimal("min_amount"));
        offer.setMaxAmount(rs.getBigDecimal("max_amount"));

        Date start = rs.getDate("start_date");
        if (start != null) {
            offer.setStartDate(start.toLocalDate());
        }

        Date end = rs.getDate("end_date");
        if (end != null) {
            offer.setEndDate(end.toLocalDate());
        }

        offer.setIsActive(rs.getBoolean("is_active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            offer.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            offer.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return offer;
    }
}
