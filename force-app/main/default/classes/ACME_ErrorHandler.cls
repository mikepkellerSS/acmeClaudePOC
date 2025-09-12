public with sharing class ACME_ErrorHandler {
    public static void logError(String className, String methodName, Exception ex) {
        System.debug(LoggingLevel.ERROR, 'Error in ' + className + '.' + methodName + ': ' + ex.getMessage());
        System.debug(LoggingLevel.ERROR, 'Stack trace: ' + ex.getStackTraceString());
        
        // In a real implementation, you might want to:
        // - Insert error records into a custom object
        // - Send email notifications
        // - Integrate with external logging systems
    }
    
    public static void logError(String className, String methodName, String errorMessage) {
        System.debug(LoggingLevel.ERROR, 'Error in ' + className + '.' + methodName + ': ' + errorMessage);
    }
}