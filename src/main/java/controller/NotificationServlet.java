package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

import model.Account;
import model.Notification;
import model.User;
import services.AccountService;
import services.NotificationService;
import services.ServiceResult;

@WebServlet("/notification")
public class NotificationServlet extends HttpServlet {

    private NotificationService notificationService;
    private AccountService accountService;

    @Override
    public void init() throws ServletException {
        notificationService = new NotificationService();
        accountService = new AccountService();
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action)) {
            listNotifications(req, resp);

        } else if ("markRead".equals(action)) {
            markAsRead(req, resp);

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

    // 1️⃣ VIEW NOTIFICATIONS
    private void listNotifications(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        String accIdStr = req.getParameter("accountId");
        if (accIdStr == null || accIdStr.isEmpty()) {
            resp.sendRedirect("dashboard.jsp?error=Invalid account");
            return;
        }

        int accountId = Integer.parseInt(accIdStr);

        // 🔐 OWNERSHIP CHECK
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<List<Notification>> result =
                notificationService.viewNotifications(accountId);

        if (!result.isSuccess()) {
            resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
            return;
        }

        req.getSession().setAttribute("notifications", result.getData());
        resp.sendRedirect("notifications.jsp");
    }

    // 2️⃣ MARK NOTIFICATION AS READ
    private void markAsRead(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        String notiIdStr = req.getParameter("notificationId");
        String accIdStr = req.getParameter("accountId");

        if (notiIdStr == null || accIdStr == null) {
            resp.sendRedirect("notifications.jsp?error=Invalid request");
            return;
        }

        int notificationId = Integer.parseInt(notiIdStr);
        int accountId = Integer.parseInt(accIdStr);

        // 🔐 OWNERSHIP CHECK
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result =
                notificationService.markNotificationAsRead(notificationId);

        resp.sendRedirect(
                result.isSuccess()
                        ? "notification?action=list&accountId=" + accountId
                        : "notifications.jsp?error=" + result.getMessage()
        );
    }
}
