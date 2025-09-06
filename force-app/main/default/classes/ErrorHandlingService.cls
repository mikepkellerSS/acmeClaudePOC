public with sharing class ErrorHandlingService {
    public static void logError(Exception e) {
        try {
            Error_Log__c errorLog = new Error_Log__c(
                Error_Message__c = e.getMessage(),
                Error_Stack_Trace__c = e.getStackTraceString(),
                Error_Type__c = e.getTypeName()
            );
            insert errorLog;
        } catch (Exception logException) {
            System.debug('Error logging failed: ' + logException.getMessage());
        }
    }
}