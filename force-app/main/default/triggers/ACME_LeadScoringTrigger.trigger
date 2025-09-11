/**
 * Lead Scoring Trigger for Acme Corp
 * Manages lead scoring calculations on insert and update
 * @author Acme Corp Development Team
 * @date 2024
 */
trigger ACME_LeadScoringTrigger on Lead (before insert, before update, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            List<Lead> leadsToScore = Trigger.new;
            leadsToScore = ACME_LeadScoringService.calculateLeadScores(leadsToScore);
        }
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Lead> leadsToTrack = new List<Lead>();
        for (Lead newLead : (List<Lead>)Trigger.new) {
            Lead oldLead = (Lead)Trigger.oldMap.get(newLead.Id);
            if (newLead.ACME__Lead_Score__c != oldLead.ACME__Lead_Score__c) {
                leadsToTrack.add(newLead);
            }
        }

        if (!leadsToTrack.isEmpty()) {
            for (Lead lead : leadsToTrack) {
                ACME_LeadScoringService.createLeadScoringHistory(
                    (Lead)Trigger.oldMap.get(lead.Id), 
                    lead
                );
            }
        }
    }
}