/**
 * @description Trigger to handle lead scoring on record changes
 * @author Studio Science
 * @date 2024-03-15
 */
trigger ACME_LeadTrigger on Lead (before update, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Pre-scoring logic if needed
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        // Process lead scoring after update
        for (Lead lead : Trigger.new) {
            // Only recalculate if relevant fields change
            if (isScoreRelevantFieldChanged(lead, Trigger.oldMap.get(lead.Id))) {
                ACME_LeadScoringService.updateLeadScore(lead.Id);
            }
        }
    }
    
    /**
     * Determine if fields relevant to scoring have changed
     * @param newLead Updated lead record
     * @param oldLead Original lead record
     * @return Boolean indicating if scoring recalculation is needed
     */
    private static Boolean isScoreRelevantFieldChanged(Lead newLead, Lead oldLead) {
        return (newLead.NumberOfEmailInteractions__c != oldLead.NumberOfEmailInteractions__c) ||
               (newLead.Title != oldLead.Title);
    }
}