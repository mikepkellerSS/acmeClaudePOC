/**
 * Trigger to automatically calculate and update lead scores
 */
trigger ACME_LeadScoreTrigger on Lead (before insert, before update) {
    // Process each lead record
    for (Lead leadRecord : Trigger.new) {
        // Calculate lead score
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(leadRecord);
        
        // Update lead with calculated score
        ACME_LeadScoringService.updateLeadScore(leadRecord.Id, calculatedScore);
    }
}