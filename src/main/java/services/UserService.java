package services;

import dao.UserDAO;
import model.User;
import model.User.Status;
import services.exception.UserServiceException;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    // 1️⃣ REGISTER USER
    public ServiceResult<Void> registerUser(User user) {

        if (user == null)
            return ServiceResult.failure("User data is required");

        if (user.getEmail() == null || user.getEmail().isEmpty())
            return ServiceResult.failure("Email is required");

        if (user.getPhone() == null || user.getPhone().isEmpty())
            return ServiceResult.failure("Phone number is required");

        try {
            if (userDAO.isEmailExists(user.getEmail()))
                return ServiceResult.failure("Email already exists");

            if (userDAO.isPhoneExists(user.getPhone()))
                return ServiceResult.failure("Phone already exists");

            user.setStatus(Status.ACTIVE);
            user.setIsVerified(false);

            boolean created = userDAO.registerUser(user);

            if (!created)
                return ServiceResult.failure("User registration failed");

            return ServiceResult.success("User registered successfully", null);

        } catch (Exception e) {
            throw new UserServiceException("Error while registering user");
        }
    }

    // 2️⃣ LOGIN USER
    public ServiceResult<User> loginUser(String email, String password) {

        if (email == null || password == null)
            return ServiceResult.failure("Email and password are required");

        try {
            User user = userDAO.loginUser(email, password);

            if (user == null)
                return ServiceResult.failure("Invalid credentials or user blocked");

            if (user.getStatus() == Status.BLOCKED)
                return ServiceResult.failure("User account is blocked");

            if (user.getStatus() == Status.DELETED)
                return ServiceResult.failure("User account is deleted");

            return ServiceResult.success("Login successful", user);

        } catch (Exception e) {
            throw new UserServiceException("Error during login");
        }
    }

    // 3️⃣ LOGOUT USER
    public ServiceResult<Void> logoutUser() {
        // session destroy servlet karega
        return ServiceResult.success("Logout successful", null);
    }

    // 4️⃣ VERIFY USER
    public ServiceResult<Void> verifyUser(int userId) {

        try {
            boolean updated = userDAO.updateVerificationStatus(userId, true);

            if (!updated)
                return ServiceResult.failure("User verification failed");

            return ServiceResult.success("User verified successfully", null);

        } catch (Exception e) {
            throw new UserServiceException("Error while verifying user");
        }
    }

    // 5️⃣ UPDATE PROFILE
    public ServiceResult<Void> updateProfile(User user) {

        if (user == null || user.getUserId() == null)
            return ServiceResult.failure("User ID is required");

        try {
            User dbUser = userDAO.getUserById(user.getUserId());

            if (dbUser == null)
                return ServiceResult.failure("User not found");

            if (dbUser.getStatus() == Status.DELETED)
                return ServiceResult.failure("Deleted user cannot update profile");

            boolean updated = userDAO.updateUserProfile(user);

            if (!updated)
                return ServiceResult.failure("Profile update failed");

            return ServiceResult.success("Profile updated successfully", null);

        } catch (Exception e) {
            throw new UserServiceException("Error while updating profile");
        }
    }

    // 6️⃣ CHANGE PASSWORD
    public ServiceResult<Void> changePassword(int userId, String newPassword) {

        if (newPassword == null || newPassword.length() < 6)
            return ServiceResult.failure("Password must be at least 6 characters");

        try {
            boolean updated = userDAO.updatePassword(userId, newPassword);

            if (!updated)
                return ServiceResult.failure("Password update failed");

            return ServiceResult.success("Password changed successfully", null);

        } catch (Exception e) {
            throw new UserServiceException("Error while changing password");
        }
    }

    // 7️⃣ BLOCK USER
    public ServiceResult<Void> blockUser(int userId) {

        try {
            boolean updated = userDAO.updateUserStatus(userId, Status.BLOCKED);

            if (!updated)
                return ServiceResult.failure("Failed to block user");

            return ServiceResult.success("User blocked successfully", null);

        } catch (Exception e) {
            throw new UserServiceException("Error while blocking user");
        }
    }

    // 8️⃣ DELETE USER
    public ServiceResult<Void> deleteUser(int userId) {

        try {
            boolean updated = userDAO.updateUserStatus(userId, Status.DELETED);

            if (!updated)
                return ServiceResult.failure("Failed to delete user");

            return ServiceResult.success("User deleted successfully", null);

        } catch (Exception e) {
            throw new UserServiceException("Error while deleting user");
        }
    }
}

