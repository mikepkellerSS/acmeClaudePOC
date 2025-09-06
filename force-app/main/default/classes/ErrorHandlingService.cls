public with sharing class ErrorHandlingService {
    
    /**
     * Logs an error with a custom message
     * @param errorMessage The error message to log
     * @param relatedRecord Optional record associated with the error
     */
    public static void logError(String errorMessage, SObject relatedRecord) {
        try {
            // Create an Error Log record
            Error_Log__c errorLog = new Error_Log__c(
                Error_Message__c = errorMessage,
                Timestamp__c = System.now()
            );
            
            // Add related record ID if provided
            if (relatedRecord != null) {
                errorLog.Related_Record_ID__c = String.valueOf(relatedRecord.Id);
            }
            
            // Insert the error log
            insert errorLog;
        } catch (Exception ex) {
            // Fallback error logging (system debug)
            System.debug('Error logging failed: ' + ex.getMessage());
        }
    }
    
    /**
     * Handles and logs exceptions
     * @param ex The exception to handle
     * @param additionalContext Optional additional context information
     */
    public static void handleException(Exception ex, String additionalContext) {
        String errorMessage = 'Exception: ' + ex.getTypeName() + 
                               '\nMessage: ' + ex.getMessage() + 
                               '\nLine Number: ' + ex.getLineNumber();
        
        if (String.isNotBlank(additionalContext)) {
            errorMessage += '\nContext: ' + additionalContext;
        }
        
        logError(errorMessage, null);
    }
}