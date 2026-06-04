package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

import model.Account;
import model.User;
import services.AccountService;
import services.ServiceResult;
import services.TransactionService;

@WebServlet("/transaction")
public class TransactionServlet extends HttpServlet {

    private TransactionService transactionService;
    private AccountService accountService;

    @Override
    public void init() throws ServletException {
        transactionService = new TransactionService();
        accountService = new AccountService();
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
            case "transfer":
                transferMoney(req, resp);
                break;

            case "receive":
                receiveMoney(req, resp);
                break;

            default:
                resp.sendRedirect("error.jsp");
        }
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("history".equals(action)) {
            transactionHistory(req, resp);

        } else if ("validateBeneficiary".equals(action)) {
            validateBeneficiary(req, resp);

        } else {
            resp.sendRedirect("error.jsp");
        }
    }

    // =====================================================
    // ================= COMMON SESSION ====================
    // =====================================================
    private User getLoggedUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return null;
        }

        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return null;
        }

        return user;
    }

    // =====================================================
    // ================= HANDLER METHODS ===================
    // =====================================================

    // 1️⃣ VALIDATE BENEFICIARY
    private void validateBeneficiary(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int senderAccountId = Integer.parseInt(req.getParameter("senderAccountId"));
        int receiverAccountId = Integer.parseInt(req.getParameter("receiverAccountId"));

        ServiceResult<Account> senderResult =
                accountService.getAccountDetails(senderAccountId);

        if (!senderResult.isSuccess()
                || !senderResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result =
                transactionService.validateBeneficiary(
                        senderAccountId, receiverAccountId);

        resp.sendRedirect(
                result.isSuccess()
                        ? "transfer.jsp?msg=beneficiaryValid"
                        : "transfer.jsp?error=" + result.getMessage()
        );
    }

    //// 2️⃣ TRANSFER MONEY
    private void transferMoney(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int senderAccountId   = Integer.parseInt(req.getParameter("senderAccountId"));
        int receiverAccountId = Integer.parseInt(req.getParameter("receiverAccountId"));

        String amtStr = req.getParameter("amount");
        if (amtStr == null || amtStr.isEmpty()) {
            resp.sendRedirect("transfer.jsp?error=Invalid amount");
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amtStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("transfer.jsp?error=Invalid amount format");
            return;
        }

        ServiceResult<Account> senderResult =
                accountService.getAccountDetails(senderAccountId);

        if (!senderResult.isSuccess()
                || !senderResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result =
                transactionService.transferMoney(
                        senderAccountId, receiverAccountId, amount);

        if (result.isSuccess()) {
            // ── Session refresh ──
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.removeAttribute("activeAccount");
                session.removeAttribute("accounts");
            }
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            resp.sendRedirect("transfer.jsp?error=" + result.getMessage());
        }
    }

    // 3️⃣ RECEIVE MONEY
    private void receiveMoney(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int receiverAccountId =
                Integer.parseInt(req.getParameter("receiverAccountId"));

        String amtStr = req.getParameter("amount");
        if (amtStr == null || amtStr.isEmpty()) {
            resp.sendRedirect("receive.jsp?error=Invalid amount");
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amtStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("receive.jsp?error=Invalid amount format");
            return;
        }

        ServiceResult<Account> receiverResult =
                accountService.getAccountDetails(receiverAccountId);

        if (!receiverResult.isSuccess()
                || !receiverResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result =
                transactionService.receiveMoney(receiverAccountId, amount);

        resp.sendRedirect(
                result.isSuccess()
                        ? "dashboard.jsp?msg=amountReceived"
                        : "receive.jsp?error=" + result.getMessage()
        );
    }

    // 4️⃣ TRANSACTION HISTORY
    private void transactionHistory(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));

        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<java.util.List<model.Transaction>> txResult =
                transactionService.getTransactionHistory(accountId);

        if (!txResult.isSuccess()) {
            resp.sendRedirect("accounts.jsp?error=" + txResult.getMessage());
            return;
        }

        req.getSession().setAttribute("transactions", txResult.getData());
        resp.sendRedirect("transactionHistory.jsp");
    }
}
