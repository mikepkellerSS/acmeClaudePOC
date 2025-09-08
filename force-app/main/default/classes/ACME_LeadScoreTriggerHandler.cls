/**
 * @description Trigger handler for lead scoring
 */
public with sharing class ACME_LeadScoreTriggerHandler {
    
    /**
     * Handles before insert trigger event
     * @param newLeads List of new leads
     */
    public void onBeforeInsert(List<Lead> newLeads) {
        ACME_LeadScoringService.calculateLeadScores(newLeads);
    }
    
    /**
     * Handles before update trigger event
     * @param oldLeads Map of old lead records
     * @param newLeads List of updated leads
     */
    public void onBeforeUpdate(Map<Id, Lead> oldLeads, List<Lead> newLeads) {
        List<Lead> leadsToScore = new List<Lead>();
        
        for (Lead newLead : newLeads) {
            Lead oldLead = oldLeads.get(newLead.Id);
            
            // Only score leads with significant changes
            if (hasRelevantChanges(oldLead, newLead)) {
                leadsToScore.add(newLead);
            }
        }
        
        if (!leadsToScore.isEmpty()) {
            ACME_LeadScoringService.calculateLeadScores(leadsToScore);
        }
    }
    
    /**
     * Determines if lead has changes relevant to scoring
     * @param oldLead Original lead record
     * @param newLead Updated lead record
     * @return Boolean indicating if scoring should be recalculated
     */
    private Boolean hasRelevantChanges(Lead oldLead, Lead newLead) {
        return (
            oldLead.NumberOfEmployees != newLead.NumberOfEmployees ||
            oldLead.Industry != newLead.Industry ||
            oldLead.Website_Visits__c != newLead.Website_Visits__c ||
            oldLead.Email_Opens__c != newLead.Email_Opens__c
        );
    }
}