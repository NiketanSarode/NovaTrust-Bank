package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.List;

import model.Account;
import model.Loan;
import model.User;
import services.AccountService;
import services.LoanService;
import services.ServiceResult;

@WebServlet("/loan")
public class LoanServlet extends HttpServlet {

    private LoanService loanService;
    private AccountService accountService;

    @Override
    public void init() throws ServletException {
        loanService    = new LoanService();
        accountService = new AccountService();
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("options".equals(action)) {
            viewLoanOptions(req, resp);
        } else if ("myLoans".equals(action)) {
            viewMyLoans(req, resp);
        } else {
            resp.sendRedirect("error.jsp");
        }
    }

    // ================= POST =================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null || action.isEmpty()) {
            resp.sendRedirect("error.jsp");
            return;
        }

        switch (action) {
            case "eligibility": checkEligibility(req, resp); break;
            case "apply":       applyLoan(req, resp);        break;
            case "payEmi":      payEmi(req, resp);           break;
            case "payFullLoan": payFullLoan(req, resp); break;
            default:            resp.sendRedirect("error.jsp");
        }
    }

    // ─────────────────────────────────────────────
    private User getLoggedUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect("login.jsp"); return null; }
        User user = (User) session.getAttribute("loggedUser");
        if (user == null)    { resp.sendRedirect("login.jsp"); return null; }
        return user;
    }

    // ─────────────────────────────────────────────
    // 1️⃣ VIEW LOAN OPTIONS
    // ─────────────────────────────────────────────
    private void viewLoanOptions(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        ServiceResult<String> result = loanService.viewLoanOption();
        if (result.isSuccess()) {
            req.getSession().setAttribute("loanOptions", result.getData());
            resp.sendRedirect("loanOptions.jsp");
        } else {
            resp.sendRedirect("dashboard.jsp?error=" + URLEncoder.encode(result.getMessage(), "UTF-8"));
        }
    }

    // ─────────────────────────────────────────────
    // 2️⃣ CHECK ELIGIBILITY
    // ─────────────────────────────────────────────
    private void checkEligibility(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));
        String amtStr = req.getParameter("loanAmount");

        if (amtStr == null || amtStr.isEmpty()) {
            resp.sendRedirect("loanOptions.jsp?error=" + URLEncoder.encode("Invalid loan amount", "UTF-8"));
            return;
        }

        BigDecimal loanAmount;
        try {
            loanAmount = new BigDecimal(amtStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("loanOptions.jsp?error=" + URLEncoder.encode("Invalid loan amount format", "UTF-8"));
            return;
        }

        ServiceResult<Account> accResult = accountService.getAccountDetails(accountId);
        if (!accResult.isSuccess() || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result = loanService.checkLoanEligibilty(accountId, loanAmount);
        resp.sendRedirect(result.isSuccess()
                ? "loanOptions.jsp?msg=eligible"
                : "loanOptions.jsp?error=" + URLEncoder.encode(result.getMessage(), "UTF-8"));
    }

    // ─────────────────────────────────────────────
    // 3️⃣ APPLY LOAN
    // ─────────────────────────────────────────────
    private void applyLoan(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId    = Integer.parseInt(req.getParameter("accountId"));
        String amtStr    = req.getParameter("loanAmount");
        String tenureStr = req.getParameter("tenureMonths");

        if (amtStr == null || tenureStr == null) {
            resp.sendRedirect("loanOptions.jsp?error=" + URLEncoder.encode("Invalid input", "UTF-8"));
            return;
        }

        BigDecimal loanAmount;
        Integer tenureMonths;
        try {
            loanAmount   = new BigDecimal(amtStr);
            tenureMonths = Integer.parseInt(tenureStr);
        } catch (Exception e) {
            resp.sendRedirect("loanOptions.jsp?error=" + URLEncoder.encode("Invalid input format", "UTF-8"));
            return;
        }

        ServiceResult<Account> accResult = accountService.getAccountDetails(accountId);
        if (!accResult.isSuccess() || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Loan> result = loanService.applyForLoan(
                loggedUser.getUserId(), accountId, loanAmount, tenureMonths);
        if (result.isSuccess()) {
            // Session refresh
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("activeAccount");
                session.removeAttribute("accounts");
            }
            req.getSession().setAttribute("loan", result.getData());
            resp.sendRedirect("loanSuccess.jsp");
        } else {
            resp.sendRedirect("loanOptions.jsp?error=" + URLEncoder.encode(result.getMessage(), "UTF-8"));
        }
    }

    // ─────────────────────────────────────────────
    // 4️⃣ VIEW MY LOANS
    // ─────────────────────────────────────────────

    private void viewMyLoans(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        // Accounts refresh karo
        ServiceResult<List<Account>> accResult = accountService.getUserAccounts(loggedUser.getUserId());
        if (accResult.isSuccess()) {
            HttpSession session = req.getSession(false);
            List<Account> accounts = accResult.getData();
            session.setAttribute("accounts", accounts);

            // activeAccount bhi update karo
            Account activeAccount = (Account) session.getAttribute("activeAccount");
            if (activeAccount != null) {
                for (Account acc : accounts) {
                    if (acc.getAccountId().equals(activeAccount.getAccountId())) {
                        session.setAttribute("activeAccount", acc);
                        break;
                    }
                }
            }
        }

        ServiceResult<List<Loan>> result = loanService.getUserLoans(loggedUser.getUserId());
        if (result.isSuccess()) {
            req.getSession().setAttribute("myLoans", result.getData());
            resp.sendRedirect("myLoans.jsp");
        } else {
            resp.sendRedirect("loanOptions.jsp?error=" + URLEncoder.encode(result.getMessage(), "UTF-8"));
        }
    }
 // 6️⃣ PAY FULL LOAN
    private void payFullLoan(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int loanId    = Integer.parseInt(req.getParameter("loanId"));
        int accountId = Integer.parseInt(req.getParameter("accountId"));

        // Ownership check
        ServiceResult<Account> accResult = accountService.getAccountDetails(accountId);
        if (!accResult.isSuccess() || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result = loanService.payFullLoan(loanId, accountId);

        // Session refresh
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("activeAccount");
            session.removeAttribute("accounts");
        }

        if (result.isSuccess()) {
            resp.sendRedirect(req.getContextPath() + "/loan?action=myLoans&msg=loanClosed");
        } else {
            resp.sendRedirect(req.getContextPath() + "/loan?action=myLoans&error="
                    + URLEncoder.encode(result.getMessage(), "UTF-8"));
        }
    }

    // ─────────────────────────────────────────────
    // 5️⃣ PAY EMI
    // ─────────────────────────────────────────────
    private void payEmi(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int loanId    = Integer.parseInt(req.getParameter("loanId"));
        int accountId = Integer.parseInt(req.getParameter("accountId"));

        // Ownership check
        ServiceResult<Account> accResult = accountService.getAccountDetails(accountId);
        if (!accResult.isSuccess() || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result = loanService.payEmi(loanId, accountId);

        if (result.isSuccess()) {
            // Session refresh karo — activeAccount aur accounts update honge
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("activeAccount");
                session.removeAttribute("accounts");
            }
            resp.sendRedirect(req.getContextPath() + "/loan?action=myLoans&msg=emiPaid");
        } else {
            resp.sendRedirect(req.getContextPath() + "/loan?action=myLoans&error="
                    + URLEncoder.encode(result.getMessage(), "UTF-8"));
        }
    }
}