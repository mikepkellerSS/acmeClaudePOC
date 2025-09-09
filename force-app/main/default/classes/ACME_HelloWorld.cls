/**
 * @description Demonstrates a simple Hello World implementation
 * @author Studio Science
 * @date 2024-02-20
 * @group Utility
 */
public with sharing class ACME_HelloWorld {
    
    /**
     * Returns a greeting message
     * @return String greeting message
     */
    public static String sayHello() {
        try {
            return 'Hello, Salesforce World!';
        } catch (Exception e) {
            // Utilize standard error handling pattern
            return 'Error: ' + e.getMessage();
        }
    }
}