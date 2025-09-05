trigger ACME_LeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ACME_LeadScoringTriggerHandler.handleLeadScoring(Trigger.new, null);
        }
        
        if (Trigger.isUpdate) {
            ACME_LeadScoringTriggerHandler.handleLeadScoring(Trigger.new, Trigger.old);
        }
    }
}