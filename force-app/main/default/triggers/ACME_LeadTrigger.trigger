/**
 * Lead trigger to manage lead scoring process
 * Follows Studio Science Trigger Framework principles
 */
trigger ACME_LeadTrigger on Lead (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        // Process lead scoring for affected leads
        ACME_LeadScoringService.updateLeadScores(Trigger.new);
    }
}