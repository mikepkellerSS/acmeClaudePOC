/**
 * @description Trigger to invoke lead scoring service on lead insert and update
 * @author Acme Corp Development Team
 * @date 2024-02-15
 */
trigger ACME_LeadScoringTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ACME_LeadScoringService.calculateLeadScores(Trigger.new);
    }
}