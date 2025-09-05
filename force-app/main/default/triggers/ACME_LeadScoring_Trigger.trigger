/**
 * @description Trigger to update lead score on create and update
 * @author Studio Science
 * @date 2025-09-05
 */
trigger ACME_LeadScoring_Trigger on Lead (before insert, before update) {
    for (Lead leadRecord : Trigger.new) {
        // Calculate lead score
        Integer leadScore = ACME_LeadScoring_Service.calculateLeadScore(leadRecord);
        
        // Update lead score and last updated timestamp
        leadRecord.ACME_LeadScore__c = leadScore;
        leadRecord.ACME_ScoringLastUpdated__c = System.now();
    }
}