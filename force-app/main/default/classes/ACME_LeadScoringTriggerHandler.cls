/**
 * @description Trigger handler for real-time lead scoring updates
 * @author Studio Science
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringTriggerHandler {
    
    /**
     * Handle lead before insert event
     * @param newLeads List of new leads
     */
    public void handleBeforeInsert(List<Lead> newLeads) {
        for (Lead lead : newLeads) {
            updateLeadScore(lead);
        }
    }
    
    /**
     * Handle lead before update event
     * @param newLeads List of updated leads
     * @param oldLeads Map of old lead records
     */
    public void handleBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        for (Lead lead : newLeads) {
            Lead oldLead = oldLeads.get(lead.Id);
            
            // Rescore if relevant fields change
            if (isRescoringRequired(lead, oldLead)) {
                updateLeadScore(lead);
            }
        }
    }
    
    /**
     * Update lead score for a single lead
     * @param lead Lead to score
     */
    private void updateLeadScore(Lead lead) {
        lead.ACME_Lead_Score__c = ACME_LeadScoringService.calculateLeadScore(lead);
        lead.ACME_Last_Scored_Date__c = System.now();
    }
    
    /**
     * Determine if lead requires rescoring
     * @param newLead Updated lead
     * @param oldLead Original lead
     * @return Boolean indicating if rescoring is needed
     */
    private Boolean isRescoringRequired(Lead newLead, Lead oldLead) {
        return (
            newLead.NumberOfEmployees != oldLead.NumberOfEmployees ||
            newLead.Industry != oldLead.Industry ||
            newLead.Title != oldLead.Title ||
            newLead.Country != oldLead.Country
        );
    }
}