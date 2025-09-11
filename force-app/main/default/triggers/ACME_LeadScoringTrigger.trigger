/**
 * @description Trigger to invoke lead scoring service on lead insert and update
 * @author Acme Corp
 * @date 2024
 */
trigger ACME_LeadScoringTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        List<Lead> leadsToScore = Trigger.new;
        ACME_LeadScoringService.calculateLeadScores(leadsToScore);
    }
}