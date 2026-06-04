package dao;

import model.Loan;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanDAO {

    // CREATE LOAN (APPLY)
    public boolean createLoan(Loan loan) {

        String sql = "INSERT INTO loans " +
                "(user_id, account_id, loan_amount, interest_rate, tenure_months, " +
                "monthly_emi, loan_status, start_date, end_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, loan.getUserId());
            ps.setInt(2, loan.getAccountId());
            ps.setBigDecimal(3, loan.getLoanAmount());
            ps.setBigDecimal(4, loan.getInterestRate());
            ps.setInt(5, loan.getTenureMonths());

            // monthly_emi (may be null at APPLY stage)
            if (loan.getMonthlyEmi() != null) {
                ps.setBigDecimal(6, loan.getMonthlyEmi());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }

            // loan_status (DB default allowed)
            if (loan.getLoanStatus() != null) {
                ps.setString(7, loan.getLoanStatus().name());
            } else {
                ps.setNull(7, Types.VARCHAR);
            }

            // start_date
            if (loan.getStartDate() != null) {
                ps.setDate(8, Date.valueOf(loan.getStartDate()));
            } else {
                ps.setNull(8, Types.DATE);
            }

            // end_date
            if (loan.getEndDate() != null) {
                ps.setDate(9, Date.valueOf(loan.getEndDate()));
            } else {
                ps.setNull(9, Types.DATE);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // GET LOAN BY ID
    public Loan getLoanById(int loanId) {

        String sql = "SELECT * FROM loans WHERE loan_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, loanId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapLoan(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // GET ALL LOANS OF USER
    public List<Loan> getLoansByUserId(int userId) {

        List<Loan> list = new ArrayList<>();
        String sql = "SELECT * FROM loans WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapLoan(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE LOAN STATUS (ENUM SAFE)
    public boolean updateLoanStatus(int loanId, Loan.LoanStatus status) {

        String sql = "UPDATE loans SET loan_status = ? WHERE loan_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ps.setInt(2, loanId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
 // GET LOANS BY ACCOUNT ID
    public List<Loan> getLoansByAccountId(int accountId) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT * FROM loans WHERE account_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapLoan(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // GET LOANS BY STATUS
    public List<Loan> getLoansByStatus(Loan.LoanStatus status) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT * FROM loans WHERE loan_status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapLoan(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // RESULTSET → LOAN (ENUM SAFE)
    private Loan mapLoan(ResultSet rs) throws SQLException {

        Loan loan = new Loan();

        loan.setLoanId(rs.getInt("loan_id"));
        loan.setUserId(rs.getInt("user_id"));
        loan.setAccountId(rs.getInt("account_id"));
        loan.setLoanAmount(rs.getBigDecimal("loan_amount"));
        loan.setInterestRate(rs.getBigDecimal("interest_rate"));
        loan.setTenureMonths(rs.getInt("tenure_months"));
        loan.setMonthlyEmi(rs.getBigDecimal("monthly_emi"));

        String status = rs.getString("loan_status");
        if (status != null) {
            loan.setLoanStatus(Loan.LoanStatus.valueOf(status));
        }

        Date start = rs.getDate("start_date");
        if (start != null) {
            loan.setStartDate(start.toLocalDate());
        }

        Date end = rs.getDate("end_date");
        if (end != null) {
            loan.setEndDate(end.toLocalDate());
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            loan.setCreatedAt(createdAt.toLocalDateTime());
        }

        return loan;
    }
}
