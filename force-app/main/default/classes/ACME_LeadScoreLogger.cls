/**
 * @description Centralized logging utility for lead scoring events
 * @author Studio Science
 * @date 2025-09-09
 */
public with sharing class ACME_LeadScoreLogger {
    
    /**
     * Log error events during lead scoring process
     * @param errorMessage Descriptive error message
     * @param ex Exception that occurred
     */
    public static void logError(String errorMessage, Exception ex) {
        try {
            // Implement logging strategy (e.g., Platform Event, Custom Object, or System Debug)
            System.debug(LoggingLevel.ERROR, errorMessage + ': ' + ex.getMessage());
            
            // Optional: Create a custom logging record or platform event
            // This is a placeholder for more robust logging
        } catch (Exception logEx) {
            // Fallback error logging
            System.debug(LoggingLevel.ERROR, 'Logging failed: ' + logEx.getMessage());
        }
    }
    
    /**
     * Log informational events during lead scoring
     * @param message Informational message to log
     */
    public static void logInfo(String message) {
        System.debug(LoggingLevel.INFO, 'ACME Lead Scoring: ' + message);
    }
}