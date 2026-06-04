package services;

import dao.AccountDAO;
import dao.OfferDAO;
import model.Account;
import model.Offer;
import model.Account.AccountStatus;
import services.exception.OfferServiceException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class OfferService {

    private final OfferDAO offerDAO;
    private final AccountDAO accountDAO;

    public OfferService() {
        this.offerDAO = new OfferDAO();
        this.accountDAO = new AccountDAO();
    }

    // 1️⃣ APPLY SIGNUP BONUS (AUTO CREDIT AFTER REGISTRATION)
    public ServiceResult<Void> applySignupBonus(
            int accountId,
            BigDecimal bonusAmount) {

        if (bonusAmount == null || bonusAmount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid signup bonus amount");

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Signup bonus can be applied only to active account");

            BigDecimal newBalance =
                    account.getBalance().add(bonusAmount);

            boolean updated =
                    accountDAO.updateBalance(accountId, newBalance);

            if (!updated)
                return ServiceResult.failure("Failed to apply signup bonus");

            return ServiceResult.success("Signup bonus applied successfully", null);

        } catch (Exception e) {
            throw new OfferServiceException("Error while applying signup bonus", e);
        }
    }

    // 2️⃣ VIEW ALL ACTIVE OFFERS
    public ServiceResult<List<Offer>> viewOffers() {

        try {
            List<Offer> offers = offerDAO.getActiveOffers();

            if (offers.isEmpty())
                return ServiceResult.failure("No active offers available");

            return ServiceResult.success("Active offers fetched successfully", offers);

        } catch (Exception e) {
            throw new OfferServiceException("Error while fetching offers", e);
        }
    }

    // 3️⃣ APPLY COUPON ON ACCOUNT
    public ServiceResult<BigDecimal> applyCoupon(
            int accountId,
            int offerId,
            BigDecimal transactionAmount) {

        if (transactionAmount == null || transactionAmount.compareTo(BigDecimal.ZERO) <= 0)
            return ServiceResult.failure("Invalid transaction amount");

        try {
            Account account = accountDAO.getAccountById(accountId);

            if (account == null)
                return ServiceResult.failure("Account not found");

            if (account.getStatus() != AccountStatus.ACTIVE)
                return ServiceResult.failure("Offer can be applied only on active account");

            Offer offer = offerDAO.getOfferById(offerId);

            if (offer == null)
                return ServiceResult.failure("Offer not found");

            // active check
            if (!Boolean.TRUE.equals(offer.getIsActive()))
                return ServiceResult.failure("Offer is not active");

            LocalDate today = LocalDate.now();

            // expiry check
            if (offer.getStartDate() != null && today.isBefore(offer.getStartDate()))
                return ServiceResult.failure("Offer not started yet");

            if (offer.getEndDate() != null && today.isAfter(offer.getEndDate()))
                return ServiceResult.failure("Offer has expired");

            // minimum amount condition
            if (offer.getMinAmount() != null &&
                transactionAmount.compareTo(offer.getMinAmount()) < 0)
                return ServiceResult.failure("Transaction amount does not meet minimum offer requirement");

            // calculate benefit amount (simple logic)
            BigDecimal benefit = offer.getMaxAmount();

            if (benefit == null || benefit.compareTo(BigDecimal.ZERO) <= 0)
                return ServiceResult.failure("Invalid offer benefit");

            // credit offer benefit
            BigDecimal newBalance =
                    account.getBalance().add(benefit);

            boolean updated =
                    accountDAO.updateBalance(accountId, newBalance);

            if (!updated)
                return ServiceResult.failure("Failed to apply offer");

            return ServiceResult.success("Offer applied successfully", benefit);

        } catch (Exception e) {
            throw new OfferServiceException("Error while applying coupon", e);
        }
    }
}
