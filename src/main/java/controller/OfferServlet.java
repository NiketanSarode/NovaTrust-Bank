package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

import model.Account;
import model.Offer;
import model.User;
import services.AccountService;
import services.OfferService;
import services.ServiceResult;

@WebServlet("/offer")
public class OfferServlet extends HttpServlet {

    private OfferService offerService;
    private AccountService accountService;

    @Override
    public void init() throws ServletException {
        offerService = new OfferService();
        accountService = new AccountService();
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action)) {
            listOffers(req, resp);

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

            case "signupBonus":
                applySignupBonus(req, resp);
                break;

            case "applyCoupon":
                applyCoupon(req, resp);
                break;

            default:
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

    // 1️⃣ VIEW OFFERS
    private void listOffers(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        ServiceResult<java.util.List<Offer>> result =
                offerService.viewOffers();

        if (result.isSuccess()) {
            req.getSession().setAttribute("offers", result.getData());
            resp.sendRedirect("offers.jsp");
        } else {
            resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
        }
    }

    // 2️⃣ APPLY SIGNUP BONUS
    private void applySignupBonus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));

        String amtStr = req.getParameter("bonusAmount");
        if (amtStr == null || amtStr.isEmpty()) {
            resp.sendRedirect("dashboard.jsp?error=Invalid bonus amount");
            return;
        }

        BigDecimal bonusAmount;
        try {
            bonusAmount = new BigDecimal(amtStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("dashboard.jsp?error=Invalid bonus format");
            return;
        }

        // 🔐 OWNERSHIP CHECK
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result =
                offerService.applySignupBonus(accountId, bonusAmount);

        resp.sendRedirect(
                result.isSuccess()
                        ? "dashboard.jsp?msg=signupBonusApplied"
                        : "dashboard.jsp?error=" + result.getMessage()
        );
    }

    // 3️⃣ APPLY COUPON
    private void applyCoupon(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));
        int offerId = Integer.parseInt(req.getParameter("offerId"));

        String amtStr = req.getParameter("transactionAmount");
        if (amtStr == null || amtStr.isEmpty()) {
            resp.sendRedirect("offers.jsp?error=Invalid transaction amount");
            return;
        }

        BigDecimal transactionAmount;
        try {
            transactionAmount = new BigDecimal(amtStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("offers.jsp?error=Invalid amount format");
            return;
        }

        // 🔐 OWNERSHIP CHECK
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<BigDecimal> result =
                offerService.applyCoupon(accountId, offerId, transactionAmount);

        resp.sendRedirect(
                result.isSuccess()
                        ? "dashboard.jsp?msg=offerApplied&benefit=" + result.getData()
                        : "offers.jsp?error=" + result.getMessage()
        );
    }
}
