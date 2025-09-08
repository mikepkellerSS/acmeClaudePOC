/**
 * @description Trigger handler for lead scoring updates
 */
public with sharing class ACMELeadScoringTriggerHandler {
    
    /**
     * @description Handles lead scoring on before update event
     * @param newLeads List of updated leads
     * @param oldLeads Map of leads before update
     */
    public static void handleBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        List<Lead> leadsToScore = new List<Lead>();

        for (Lead newLead : newLeads) {
            // Check if relevant fields have changed
            if (hasRelevantChanges(newLead, oldLeads.get(newLead.Id))) {
                leadsToScore.add(newLead);
            }
        }

        if (!leadsToScore.isEmpty()) {
            ACMELeadScoringService.updateLeadScores(leadsToScore);
        }
    }

    /**
     * @description Determines if lead has changes that warrant rescoring
     * @param newLead Current lead record
     * @param oldLead Previous lead record
     * @return Boolean indicating if rescore is needed
     */
    private static Boolean hasRelevantChanges(Lead newLead, Lead oldLead) {
        return (
            newLead.Number_of_Email_Opens__c != oldLead.Number_of_Email_Opens__c ||
            newLead.Website_Visits__c != oldLead.Website_Visits__c ||
            newLead.Content_Downloads__c != oldLead.Content_Downloads__c ||
            newLead.Company_Size__c != oldLead.Company_Size__c ||
            newLead.Industry != oldLead.Industry ||
            newLead.Title != oldLead.Title ||
            newLead.Country != oldLead.Country
        );
    }
}