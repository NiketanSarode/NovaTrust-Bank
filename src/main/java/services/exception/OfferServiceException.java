package services.exception;

public class OfferServiceException extends RuntimeException {

    public OfferServiceException(String message) {
        super(message);
    }

    public OfferServiceException(String message, Throwable cause) {
        super(message, cause);
    }
}
