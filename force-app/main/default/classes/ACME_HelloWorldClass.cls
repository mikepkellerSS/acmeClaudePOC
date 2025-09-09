/**
 * @description Provides a simple Hello World functionality
 * @author Studio Science
 * @date 2025-09-09
 */
public with sharing class ACME_HelloWorldClass {
    
    /**
     * Returns a Hello World greeting
     * @return String containing Hello World message
     */
    public static String sayHello() {
        try {
            // Secure, simple implementation
            return 'Hello World from Salesforce!';
        } catch (Exception e) {
            // Standard error handling pattern
            System.Logger.error('Error in sayHello: ' + e.getMessage());
            throw new AuraHandledException('Unexpected error occurred');
        }
    }
}