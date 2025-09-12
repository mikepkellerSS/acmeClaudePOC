public with sharing class ACME_SupremeCourtDecisionTriggerHandler {
    public void run() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                handleBeforeInsert((List<ACME_SupremeCourtDecision__c>) Trigger.new);
            }
            if (Trigger.isUpdate) {
                handleBeforeUpdate((List<ACME_SupremeCourtDecision__c>) Trigger.new, 
                                 (Map<Id, ACME_SupremeCourtDecision__c>) Trigger.oldMap);
            }
        }
    }
    
    private void handleBeforeInsert(List<ACME_SupremeCourtDecision__c> newDecisions) {
        for (ACME_SupremeCourtDecision__c decision : newDecisions) {
            // Validate case number format
            if (String.isBlank(decision.CaseNumber__c)) {
                decision.addError('Case Number is required.');
            }
            
            // Set default values if needed
            if (decision.DecisionDate__c == null) {
                decision.DecisionDate__c = Date.today();
            }
        }
    }
    
    private void handleBeforeUpdate(List<ACME_SupremeCourtDecision__c> newDecisions, 
                                   Map<Id, ACME_SupremeCourtDecision__c> oldDecisionMap) {
        for (ACME_SupremeCourtDecision__c decision : newDecisions) {
            ACME_SupremeCourtDecision__c oldDecision = oldDecisionMap.get(decision.Id);
            
            // Validate case number format
            if (String.isBlank(decision.CaseNumber__c)) {
                decision.addError('Case Number is required.');
            }
        }
    }
}