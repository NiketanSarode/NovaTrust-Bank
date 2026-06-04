package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

import model.User;
import model.User.Gender;
import services.UserService;
import services.ServiceResult;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private UserService userService;

    // Temporary admin email (until role is added)
    private static final String ADMIN_EMAIL = "admin@bank.com";

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null || action.isEmpty()) {
            resp.sendRedirect("error.jsp");
            return;
        }

        switch (action) {
            case "register":
                register(req, resp);
                break;

            case "login":
                login(req, resp);
                break;

            case "updateProfile":
                updateProfile(req, resp);
                break;

            case "changePassword":
                changePassword(req, resp);
                break;

            case "blockUser":
                blockUser(req, resp);
                break;

            case "deleteUser":
                deleteUser(req, resp);
                break;

            default:
                resp.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            logout(req, resp);
        } else {
            resp.sendRedirect("error.jsp");
        }
    }

    // ================= HANDLER METHODS =================

    // 1️⃣ REGISTER USER
    private void register(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User user = new User();
        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhone(req.getParameter("phone"));
        user.setPassword(req.getParameter("password"));
        user.setAddress(req.getParameter("address"));

        String gender = req.getParameter("gender");
        if (gender != null && !gender.isEmpty()) {
            user.setGender(Gender.valueOf(gender.toUpperCase()));
        }

        String dob = req.getParameter("dob");
        if (dob != null && !dob.isEmpty()) {
            user.setDob(LocalDate.parse(dob));
        }

        ServiceResult<Void> result = userService.registerUser(user);

        if (result.isSuccess()) {
        	 resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=registered");
        } else {
			resp.sendRedirect(req.getContextPath() + "/register.jsp?error=" + result.getMessage());

        }
    }

 // 2️⃣ LOGIN USER
    private void login(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        ServiceResult<User> result =
                userService.loginUser(
                        req.getParameter("email"),
                        req.getParameter("password")
                );

        if (result.isSuccess()) {

            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", result.getData());

            // ✅ IMPORTANT: Redirect to DashboardServlet (NOT JSP)
            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } else {
            resp.sendRedirect("login.jsp?error=" + result.getMessage());
        }
    }


    // 3️⃣ LOGOUT USER
    private void logout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        resp.sendRedirect("login.jsp?msg=logout");
    }

    // 4️⃣ UPDATE PROFILE
    private void updateProfile(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        user.setFullName(req.getParameter("fullName"));
        user.setPhone(req.getParameter("phone"));
        user.setAddress(req.getParameter("address"));

        ServiceResult<Void> result = userService.updateProfile(user);

        if (result.isSuccess()) {
            session.setAttribute("loggedUser", user);
            resp.sendRedirect("profile.jsp?msg=updated");
        } else {
            resp.sendRedirect("profile.jsp?error=" + result.getMessage());
        }
    }

    // 5️⃣ CHANGE PASSWORD
    private void changePassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        ServiceResult<Void> result =
                userService.changePassword(
                        user.getUserId(),
                        req.getParameter("newPassword")
                );

        if (result.isSuccess()) {
            resp.sendRedirect("profile.jsp?msg=passwordChanged");
        } else {
            resp.sendRedirect("profile.jsp?error=" + result.getMessage());
        }
    }

    // 6️⃣ BLOCK USER (ADMIN ONLY)
    private void blockUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("loggedUser");

        if (admin == null || !ADMIN_EMAIL.equals(admin.getEmail())) {
            resp.sendRedirect("unauthorized.jsp");
            return;
        }

        int userId = Integer.parseInt(req.getParameter("userId"));
        userService.blockUser(userId);

        resp.sendRedirect("adminUsers.jsp?msg=userBlocked");
    }

    // 7️⃣ DELETE USER (SELF DELETE)
    private void deleteUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        ServiceResult<Void> result =
                userService.deleteUser(user.getUserId());

        session.invalidate();

        if (result.isSuccess()) {
            resp.sendRedirect("register.jsp?msg=accountDeleted");
        } else {
            resp.sendRedirect("profile.jsp?error=" + result.getMessage());
        }
    }
}
