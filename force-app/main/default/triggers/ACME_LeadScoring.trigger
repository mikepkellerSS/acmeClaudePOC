/**
 * @description Trigger to manage lead scoring on record changes
 * @author ACME Development Team
 * @date 2024-02-15
 */
trigger ACME_LeadScoring on Lead (after insert, after update) {
    // Process leads for scoring
    for (Lead leadRecord : Trigger.new) {
        // Calculate and update lead score
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(leadRecord);
        ACME_LeadScoringService.updateLeadScore(leadRecord.Id, leadScore);
    }
}