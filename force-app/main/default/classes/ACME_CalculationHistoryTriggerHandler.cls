/**
 * Trigger handler for Calculation History records
 */
public with sharing class ACME_CalculationHistoryTriggerHandler extends ACME_TriggerHandler {
    
    protected override void beforeInsert() {
        for (ACME_CalculationHistory__c history : (List<ACME_CalculationHistory__c>) Trigger.new) {
            validateCalculationHistory(history);
        }
    }

    protected override void beforeUpdate() {
        for (ACME_CalculationHistory__c history : (List<ACME_CalculationHistory__c>) Trigger.new) {
            ACME_CalculationHistory__c oldHistory = 
                (ACME_CalculationHistory__c) Trigger.oldMap.get(history.Id);
            
            validateCalculationHistory(history);
            
            // Prevent modification of certain fields
            if (history.ACME__CalculationType__c != oldHistory.ACME__CalculationType__c) {
                history.ACME__CalculationType__c.addError('Calculation type cannot be modified');
            }
        }
    }

    /**
     * Validate calculation history record
     * @param history Calculation history record to validate
     */
    private void validateCalculationHistory(ACME_CalculationHistory__c history) {
        // Validate calculation type
        Set<String> validCalculationTypes = new Set<String>{
            'Addition', 'Subtraction', 'Multiplication', 'Division'
        };
        
        if (String.isBlank(history.ACME__CalculationType__c) || 
            !validCalculationTypes.contains(history.ACME__CalculationType__c)) {
            history.ACME__CalculationType__c.addError('Invalid calculation type');
        }

        // Validate calculation number
        if (history.ACME__CalculationHistoryNumber__c == null) {
            history.ACME__CalculationHistoryNumber__c.addError('Calculation result is required');
        }
    }
}