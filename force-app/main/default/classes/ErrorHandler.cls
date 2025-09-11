/**
 * @description Error handling utility class
 * @author Acme Corp Development Team
 * @date 2024
 */
public with sharing class ErrorHandler {
    
    /**
     * Log error information
     * @param className Name of the class where error occurred
     * @param methodName Name of the method where error occurred
     * @param ex Exception that was caught
     */
    public static void logError(String className, String methodName, Exception ex) {
        System.debug(LoggingLevel.ERROR, 'Error in ' + className + '.' + methodName + ': ' + ex.getMessage());
        System.debug(LoggingLevel.ERROR, 'Stack trace: ' + ex.getStackTraceString());
    }
}