/**
 * Trigger for Lead object to manage lead scoring
 */
trigger ACME_LeadTrigger on Lead (after insert, after update) {
    // Only process if trigger is not already running
    if (!ACME_LeadTriggerHandler.isRunning) {
        ACME_LeadTriggerHandler.isRunning = true;
        
        // Process leads for scoring
        for (Lead leadRecord : Trigger.new) {
            // Calculate lead score asynchronously
            System.enqueueJob(new LeadScoringQueueable(leadRecord.Id));
        }
        
        ACME_LeadTriggerHandler.isRunning = false;
    }
}