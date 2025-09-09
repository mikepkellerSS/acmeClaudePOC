/**
 * Handler class to prevent recursive trigger execution
 */
public with sharing class LeadTriggerHandler {
    // Static variable to prevent recursive trigger calls
    public static Boolean isRunning = false;
}