/**
 * @description Centralized error handling for ACME Calculator Service
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_ErrorHandler {
    
    /**
     * Custom exception for calculator service errors
     */
    public class CalculatorException extends Exception {}
    
    /**
     * Log and throw a custom exception
     * @param errorMessage Error message to log and throw
     */
    public static void handleError(String errorMessage) {
        System.debug(LoggingLevel.ERROR, errorMessage);
        throw new CalculatorException(errorMessage);
    }
    
    /**
     * Log an error without throwing an exception
     * @param errorMessage Error message to log
     */
    public static void logError(String errorMessage) {
        System.debug(LoggingLevel.ERROR, errorMessage);
    }
}