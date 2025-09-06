/**
 * @description Logging utility for Lead Scoring operations
 * @author Acme Corp Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringLogger {
    
    /**
     * Log error with custom message and exception details
     * @param errorMessage Custom error message
     * @param e Exception to log
     */
    public static void logError(String errorMessage, Exception e) {
        // Use Platform Event or Custom Object for logging
        System.debug(LoggingLevel.ERROR, errorMessage + ': ' + e.getMessage());
        
        // Optional: Create a custom log record
        ACME_Lead_Scoring_Log__c logEntry = new ACME_Lead_Scoring_Log__c(
            Error_Message__c = errorMessage,
            Stack_Trace__c = e.getStackTraceString(),
            Timestamp__c = System.now()
        );

        try {
            Database.insert(logEntry, false);
        } catch (Exception logException) {
            System.debug(LoggingLevel.ERROR, 'Failed to log error: ' + logException.getMessage());
        }
    }
}