public class ACME_ErrorHandler {
    public static void logError(String message, Exception ex) {
        System.debug(LoggingLevel.ERROR, message + ': ' + ex.getMessage());
    }

    public static void handleException(Exception ex) {
        logError('Unexpected error occurred', ex);
    }
}