package services;

import dao.AccountDAO;
import dao.InsurancePlanDAO;
import dao.UserInsuranceDAO;
import model.Account;
import model.InsurancePlan;
import model.UserInsurance;
import model.Account.AccountStatus;
import model.UserInsurance.InsuranceStatus;
import services.exception.InsuranceServiceException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public class InsuranceService {

    private final InsurancePlanDAO insurancePlanDAO;
    private final UserInsuranceDAO userInsuranceDAO;
    private final AccountDAO accountDAO;

    private static final BigDecimal MIN_ACCOUNT_BALANCE =
            new BigDecimal("20000");

    public InsuranceService() {
        this.insurancePlanDAO = new InsurancePlanDAO();
        this.userInsuranceDAO = new UserInsuranceDAO();
        this.accountDAO = new AccountDAO();
    }

    // 1️⃣ VIEW INSURANCE PLANS
    public ServiceResult<List<InsurancePlan>> viewInsurancePlans() {

        try {
            List<InsurancePlan> plans =
                    insurancePlanDAO.getActiveInsurancePlans();

            if (plans.isEmpty())
                return ServiceResult.failure("No insurance plans available");

            return ServiceResult.success(
                    "Insurance plans fetched successfully",
                    plans
            );

        } catch (Exception e) {
            throw new InsuranceServiceException(
                    "Error while fetching insurance plans", e);
        }
    }

    // 2️⃣ CHECK INSURANCE ELIGIBILITY
    public ServiceResult<Void> checkInsuranceEligibility(int accountId) {

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure(
                        "Only active accounts can apply for insurance");

            if (account.getBalance()
                    .compareTo(MIN_ACCOUNT_BALANCE) < 0)
                return ServiceResult.failure(
                        "Minimum balance of ₹20,000 required");

            return ServiceResult.success(
                    "Account eligible for insurance", null);

        } catch (Exception e) {
            throw new InsuranceServiceException(
                    "Error while checking insurance eligibility", e);
        }
    }

    // 3️⃣ APPLY FOR INSURANCE (AUTO APPROVED)
    public ServiceResult<UserInsurance> applyForInsurance(
            int userId,
            int accountId,
            int insuranceId) {

        try {
            // eligibility check
            ServiceResult<Void> eligibility =
                    checkInsuranceEligibility(accountId);

            if (!eligibility.isSuccess())
                return ServiceResult.failure(
                        eligibility.getMessage());

            InsurancePlan plan =
                    insurancePlanDAO.getInsurancePlanById(insuranceId);

            if (plan == null || !Boolean.TRUE.equals(plan.getIsActive()))
                return ServiceResult.failure(
                        "Invalid or inactive insurance plan");

            // create user insurance
            UserInsurance ui = new UserInsurance();

            ui.setUserId(userId);
            ui.setInsuranceId(insuranceId);
            ui.setPolicyNumber(
                    "POL-" + UUID.randomUUID().toString().substring(0, 8)
            );

            ui.setStartDate(LocalDate.now());
            ui.setEndDate(
                    LocalDate.now().plusYears(plan.getTenureYears())
            );

            ui.setPremiumAmount(plan.getPremiumAmount());
            ui.setInsuranceStatus(InsuranceStatus.ACTIVE);

            boolean created =
                    userInsuranceDAO.createUserInsurance(ui);

            if (!created)
                return ServiceResult.failure(
                        "Insurance application failed");

            return ServiceResult.success(
                    "Insurance applied successfully",
                    ui
            );

        } catch (Exception e) {
            throw new InsuranceServiceException(
                    "Error while applying for insurance", e);
        }
    }

    // 4️⃣ GET MY INSURANCES
    public ServiceResult<List<UserInsurance>> getMyInsurances(int userId) {

        try {
            List<UserInsurance> list =
                    userInsuranceDAO.getUserInsuranceByUserId(userId);

            if (list.isEmpty())
                return ServiceResult.failure(
                        "No insurance records found");

            return ServiceResult.success(
                    "User insurance list fetched successfully",
                    list
            );

        } catch (Exception e) {
            throw new InsuranceServiceException(
                    "Error while fetching user insurances", e);
        }
    }

    // 5️⃣ GET INSURANCE DETAILS
    public ServiceResult<UserInsurance> getInsuranceDetails(
            int userInsuranceId) {

        try {
            UserInsurance ui =
                    userInsuranceDAO.getUserInsuranceById(userInsuranceId);

            if (ui == null)
                return ServiceResult.failure(
                        "Insurance details not found");

            return ServiceResult.success(
                    "Insurance details fetched successfully",
                    ui
            );

        } catch (Exception e) {
            throw new InsuranceServiceException(
                    "Error while fetching insurance details", e);
        }
    }
}
