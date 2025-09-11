/**
 * @description Trigger to update lead score when lead data changes
 * @author Salesforce Architect
 * @date 2024-02-15
 */
trigger ACME_LeadScoreTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            List<Lead> leadsToScore = Trigger.new;
            ACME_LeadScoreService.updateLeadScores(leadsToScore);
        }
    }
}