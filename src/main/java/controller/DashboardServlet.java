package controller;

import javax.servlet.ServletException; 
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

import model.Account;
import model.User;
import services.AccountService;
import services.NotificationService;
import services.ServiceResult;
import services.TransactionService;
import model.Transaction;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

	private AccountService accountService;
	private NotificationService notificationService;

	
	private TransactionService transactionService;
	@Override
	public void init() throws ServletException {
	    accountService = new AccountService();
	    notificationService = new NotificationService();
	    transactionService = new TransactionService();
	}

	// ================= GET =================
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		User loggedUser = getLoggedUser(req, resp);
		if (loggedUser == null)
			return;

		String action = req.getParameter("action");

		if (action == null || action.isEmpty()) {
			loadDashboard(loggedUser, req, resp);
			return;
		}

		if ("selectAccount".equals(action)) {
			selectAccount(loggedUser, req, resp);
		} else {
			resp.sendRedirect("error.jsp");
		}
	}

	// ================= POST =================
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		doGet(req, resp); // dashboard actions handled via GET
	}

	// =====================================================
	// ================= COMMON SESSION ====================
	// =====================================================
	private User getLoggedUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {

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
	// ================= DASHBOARD LOAD ====================
	// =====================================================
	private void loadDashboard(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {

	    ServiceResult<List<Account>> result = accountService.getUserAccounts(user.getUserId());

	    if (!result.isSuccess()) {
	        resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
	        return;
	    }

	    HttpSession session = req.getSession();
	    session.setAttribute("accounts", result.getData());

	    // Set default active account if not present
	    if (session.getAttribute("activeAccount") == null && !result.getData().isEmpty()) {
	        session.setAttribute("activeAccount", result.getData().get(0));
	    }

	    // ✅ Recent transactions load karo
	    Account activeAccount = (Account) session.getAttribute("activeAccount");
	    if (activeAccount != null) {
	        ServiceResult<List<Transaction>> txResult =
	            transactionService.getTransactionHistory(activeAccount.getAccountId());
	        if (txResult.isSuccess()) {
	            session.setAttribute("recentTransactions", txResult.getData());
	        } else {
	            session.setAttribute("recentTransactions", null);
	        }
	    }

	    resp.sendRedirect("dashboard.jsp");
	}

	// =====================================================
	// ================= SELECT ACCOUNT ====================
	// =====================================================
	private void selectAccount(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {

		String accIdStr = req.getParameter("accountId");
		if (accIdStr == null || accIdStr.isEmpty()) {
			resp.sendRedirect("dashboard.jsp?error=Invalid account");
			return;
		}

		int accountId;
		try {
			accountId = Integer.parseInt(accIdStr);
		} catch (NumberFormatException e) {
			resp.sendRedirect("dashboard.jsp?error=Invalid account format");
			return;
		}

		ServiceResult<Account> result = accountService.switchAccount(accountId);

		if (!result.isSuccess()) {
			resp.sendRedirect("dashboard.jsp?error=" + result.getMessage());
			return;
		}

		Account account = result.getData();

		// 🔐 OWNERSHIP CHECK
		if (!account.getUserId().equals(user.getUserId())) {
			resp.sendRedirect("unauthorized.jsp");
			return;
		}

		req.getSession().setAttribute("activeAccount", account);

		resp.sendRedirect("dashboard.jsp?msg=accountSelected");
	}
}
