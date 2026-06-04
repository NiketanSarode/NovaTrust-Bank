package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

import model.Account;
import model.InsurancePlan;
import model.User;
import model.UserInsurance;
import services.AccountService;
import services.InsuranceService;
import services.ServiceResult;

@WebServlet("/insurance")
public class InsuranceServlet extends HttpServlet {

    private InsuranceService insuranceService;
    private AccountService accountService;

    @Override
    public void init() throws ServletException {
        insuranceService = new InsuranceService();
        accountService = new AccountService();
    }

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("plans".equals(action)) {
            viewPlans(req, resp);

        } else if ("my".equals(action)) {
            myInsurances(req, resp);

        } else if ("details".equals(action)) {
            insuranceDetails(req, resp);

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

            case "eligibility":
                checkEligibility(req, resp);
                break;

            case "apply":
                applyInsurance(req, resp);
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

    // 1️⃣ VIEW INSURANCE PLANS
    private void viewPlans(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        ServiceResult<java.util.List<InsurancePlan>> result =
                insuranceService.viewInsurancePlans();

        if (result.isSuccess()) {
            req.getSession().setAttribute("insurancePlans", result.getData());
            resp.sendRedirect("insurancePlans.jsp");
        } else {
            resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
        }
    }

    // 2️⃣ CHECK ELIGIBILITY
    private void checkEligibility(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));

        // 🔐 OWNERSHIP CHECK
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<Void> result =
                insuranceService.checkInsuranceEligibility(accountId);

        resp.sendRedirect(
                result.isSuccess()
                        ? "insurance.jsp?msg=eligible"
                        : "insurance.jsp?error=" + result.getMessage()
        );
    }

    // 3️⃣ APPLY INSURANCE
    private void applyInsurance(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int accountId = Integer.parseInt(req.getParameter("accountId"));
        int insuranceId = Integer.parseInt(req.getParameter("insuranceId"));

        // 🔐 OWNERSHIP CHECK
        ServiceResult<Account> accResult =
                accountService.getAccountDetails(accountId);

        if (!accResult.isSuccess()
                || !accResult.getData().getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        ServiceResult<UserInsurance> result =
                insuranceService.applyForInsurance(
                        loggedUser.getUserId(),
                        accountId,
                        insuranceId
                );

        if (result.isSuccess()) {
            req.getSession().setAttribute("insurance", result.getData());
            resp.sendRedirect("insuranceSuccess.jsp");
        } else {
            resp.sendRedirect("insurance.jsp?error=" + result.getMessage());
        }
    }

    // 4️⃣ MY INSURANCES
    private void myInsurances(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        ServiceResult<java.util.List<UserInsurance>> result =
                insuranceService.getMyInsurances(loggedUser.getUserId());

        if (result.isSuccess()) {
            req.getSession().setAttribute("myInsurances", result.getData());
            resp.sendRedirect("myInsurances.jsp");
        } else {
            resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
        }
    }

    // 5️⃣ INSURANCE DETAILS
    private void insuranceDetails(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User loggedUser = getLoggedUser(req, resp);
        if (loggedUser == null) return;

        int userInsuranceId =
                Integer.parseInt(req.getParameter("userInsuranceId"));

        ServiceResult<UserInsurance> result =
                insuranceService.getInsuranceDetails(userInsuranceId);

        if (!result.isSuccess()) {
            resp.sendRedirect("myInsurances.jsp?error=" + result.getMessage());
            return;
        }

        UserInsurance ui = result.getData();

        // 🔐 OWNERSHIP CHECK
        if (!ui.getUserId().equals(loggedUser.getUserId())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        req.getSession().setAttribute("insuranceDetails", ui);
        resp.sendRedirect("insuranceDetails.jsp");
    }
}
