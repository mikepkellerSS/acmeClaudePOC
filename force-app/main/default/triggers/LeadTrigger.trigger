trigger LeadTrigger on Lead (after insert, after update) {
    if (!LeadTriggerHandler.isRunning) {
        LeadTriggerHandler.isRunning = true;
        
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
            ACME_LeadScoringService.updateLeadScores(Trigger.new);
        }
        
        LeadTriggerHandler.isRunning = false;
    }
}