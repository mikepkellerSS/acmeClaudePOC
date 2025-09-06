/**
 * Lead trigger to handle scoring on lead creation and update
 */
trigger ACME_LeadTrigger on Lead (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        ACME_LeadScoringService.processLeadScores(Trigger.new);
    }
}