package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

import model.Account;
import model.Account.AccountType;
import model.User;
import services.AccountService;
import services.ServiceResult;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {

    private AccountService accountService;

    @Override
    public void init() throws ServletException {
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
            case "create":
                createAccount(req, resp);
                break;

            case "switch":
                switchAccount(req, resp);
                break;

            case "setDefault":
                setDefaultAccount(req, resp);
                break;

            case "close":
                closeAccount(req, resp);
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

        if ("details".equals(action)) {
            accountDetails(req, resp);

        } else if ("balance".equals(action)) {
            checkBalance(req, resp);

        } else {
            resp.sendRedirect("error.jsp");
        }
    }

    // =====================================================
    // ================= HANDLER METHODS ===================
    // =====================================================

    // ---------- COMMON SESSION + USER ----------
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

    // ---------- 1️⃣ CREATE ACCOUNT ----------
    private void createAccount(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        Account account = new Account();
        account.setUserId(loggedUser.getUserId());
        account.setAccountNumber(req.getParameter("accountNumber"));

        String type = req.getParameter("accountType");
        if (type != null && !type.isEmpty()) {
            account.setAccountType(AccountType.valueOf(type.toUpperCase()));
        }

        account.setBalance(BigDecimal.ZERO); // safe default

        ServiceResult<Void> result = accountService.createAccount(account);

        if (result.isSuccess()) {
            resp.sendRedirect("account.jsp?msg=accountCreated");
        } else {
            resp.sendRedirect("createAccount.jsp?error=" + result.getMessage());
        }
    }

    // ---------- 2️⃣ ACCOUNT DETAILS ----------
    private void accountDetails(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));

        ServiceResult<Account> result =
                accountService.getAccountDetails(accountId);

        if (!result.isSuccess()) {
            resp.sendRedirect("accounts.jsp?error=" + result.getMessage());
            return;
        }

        Account account = result.getData();

        // 🔐 OWNERSHIP CHECK (CRITICAL)
        if (!account.getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        req.getSession().setAttribute("selectedAccount", account);
        resp.sendRedirect("accountDetails.jsp");
    }

    // ---------- 3️⃣ CHECK BALANCE ----------
    private void checkBalance(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));

        // ownership check via account fetch
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()) {
            resp.sendRedirect("accounts.jsp?error=" + accResult.getMessage());
            return;
        }

        Account account = accResult.getData();
        if (!account.getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<BigDecimal> result =
                accountService.checkBalance(accountId);

        if (result.isSuccess()) {
            req.getSession().setAttribute("balance", result.getData());
            resp.sendRedirect("balance.jsp");
        } else {
            resp.sendRedirect("accounts.jsp?error=" + result.getMessage());
        }
    }

    // ---------- 4️⃣ SWITCH ACCOUNT ----------
    private void switchAccount(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));

        ServiceResult<Account> result =
                accountService.switchAccount(accountId);

        if (!result.isSuccess()) {
            resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
            return;
        }

        Account account = result.getData();

        // 🔐 OWNERSHIP CHECK
        if (!account.getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        req.getSession().setAttribute("activeAccount", account);
        resp.sendRedirect("dashboard.jsp?msg=accountSwitched");
    }

    // ---------- 5️⃣ SET DEFAULT ACCOUNT ----------
    private void setDefaultAccount(HttpServletRequest req, HttpServletResponse resp)
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

        ServiceResult<Void> result =
                accountService.setDefaultAccount(accountId);

        resp.sendRedirect(
                result.isSuccess()
                        ? "accounts.jsp?msg=defaultSet"
                        : "accounts.jsp?error=" + result.getMessage()
        );
    }

    // ---------- 6️⃣ CLOSE ACCOUNT ----------
    private void closeAccount(HttpServletRequest req, HttpServletResponse resp)
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

        ServiceResult<Void> result =
                accountService.closeAccount(accountId);

        resp.sendRedirect(
                result.isSuccess()
                        ? "accounts.jsp?msg=accountClosed"
                        : "accounts.jsp?error=" + result.getMessage()
        );
    }
}
