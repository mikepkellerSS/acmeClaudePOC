/**
 * Trigger handler for lead scoring
 * Manages lead scoring logic on trigger events
 */
public with sharing class ACME_LeadScoringTriggerHandler {
    
    /**
     * Handle lead scoring on before insert
     * @param newLeads List of new leads
     */
    public void handleBeforeInsert(List<Lead> newLeads) {
        for (Lead lead : newLeads) {
            Decimal score = ACME_LeadScoringService.calculateLeadScore(lead);
            lead.ACME_Lead_Score__c = score;
            lead.ACME_Last_Scored_Date__c = System.now();
        }
    }
    
    /**
     * Handle lead scoring on before update
     * @param newLeads List of updated leads
     * @param oldLeadsMap Map of old lead records
     */
    public void handleBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadsMap) {
        for (Lead lead : newLeads) {
            // Only rescore if relevant fields change
            if (hasRelevantChanges(lead, oldLeadsMap.get(lead.Id))) {
                Decimal score = ACME_LeadScoringService.calculateLeadScore(lead);
                lead.ACME_Lead_Score__c = score;
                lead.ACME_Last_Scored_Date__c = System.now();
            }
        }
    }
    
    /**
     * Determine if lead has changes that warrant rescoring
     * @param newLead Current lead record
     * @param oldLead Previous lead record
     * @return Boolean indicating if rescore is needed
     */
    private Boolean hasRelevantChanges(Lead newLead, Lead oldLead) {
        return (newLead.Industry != oldLead.Industry ||
                newLead.NumberOfEmployees != oldLead.NumberOfEmployees ||
                newLead.Website_Visits__c != oldLead.Website_Visits__c ||
                newLead.Email_Opens__c != oldLead.Email_Opens__c);
    }
}