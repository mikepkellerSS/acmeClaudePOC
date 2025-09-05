/**
 * Trigger to handle lead scoring on create and update
 */
trigger ACME_LeadTrigger on Lead (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        ACME_LeadScoringService.updateLeadScores(Trigger.new);
    }
}