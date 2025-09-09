/**
 * Trigger for Lead object to handle scoring
 */
trigger LeadTrigger on Lead (after insert, after update) {
    // Only process if trigger is not already running
    if (!LeadTriggerHandler.isRunning) {
        LeadTriggerHandler.isRunning = true;
        
        // Handle lead scoring for inserted or updated leads
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
            ACME_LeadScoringService.updateLeadScores(Trigger.new);
        }
        
        LeadTriggerHandler.isRunning = false;
    }
}