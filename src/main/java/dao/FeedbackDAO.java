package dao;

import model.Feedback;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    // CREATE FEEDBACK
    public boolean createFeedback(Feedback f) {

        String sql = "INSERT INTO feedback " +
                "(user_id, rating, comments) " +
                "VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, f.getUserId());

            // rating (1–5 expected, validate in service layer)
            if (f.getRating() != null) {
                ps.setInt(2, f.getRating());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            // comments (nullable)
            if (f.getComments() != null) {
                ps.setString(3, f.getComments());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET FEEDBACK BY ID
    public Feedback getFeedbackById(int feedbackId) {

        String sql = "SELECT * FROM feedback WHERE feedback_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapFeedback(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL FEEDBACK OF A USER
    public List<Feedback> getFeedbackByUserId(int userId) {

        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback " +
                "WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapFeedback(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // RESULTSET → FEEDBACK
    private Feedback mapFeedback(ResultSet rs) throws SQLException {

        Feedback f = new Feedback();

        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setUserId(rs.getInt("user_id"));
        f.setRating(rs.getInt("rating"));
        f.setComments(rs.getString("comments"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            f.setCreatedAt(createdAt.toLocalDateTime());
        }

        return f;
    }
}
