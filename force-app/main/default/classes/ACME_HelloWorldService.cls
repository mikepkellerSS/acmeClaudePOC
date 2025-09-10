/**
 * @description Demonstrates a simple Hello World service for Acme Corp
 * @author Studio Science
 * @date 2025-09-10
 */
public with sharing class ACME_HelloWorldService {
    
    /**
     * Returns a greeting message
     * @return String greeting message
     */
    public String sayHello() {
        try {
            return 'Hello, Salesforce World!';
        } catch (Exception ex) {
            // Use standard error handling pattern
            System.debug(LoggingLevel.ERROR, 'Error in sayHello: ' + ex.getMessage());
            throw new AcmeException('Unexpected error occurred', ex);
        }
    }

    /**
     * Custom exception for Acme Corp error handling
     */
    public class AcmeException extends Exception {}
}