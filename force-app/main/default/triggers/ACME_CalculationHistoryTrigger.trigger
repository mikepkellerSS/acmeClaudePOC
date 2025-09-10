/**
 * Trigger for managing Calculation History records
 */
trigger ACME_CalculationHistoryTrigger on ACME_CalculationHistory__c (
    before insert, 
    before update, 
    after insert, 
    after update
) {
    ACME_CalculationHistoryTriggerHandler handler = 
        new ACME_CalculationHistoryTriggerHandler();
    
    handler.run();
}