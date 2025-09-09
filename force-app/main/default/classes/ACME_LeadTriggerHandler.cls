/**
 * Handler class for Lead trigger operations
 */
public with sharing class ACME_LeadTriggerHandler {
    // Flag to prevent recursive trigger execution
    public static Boolean isRunning = false;
}