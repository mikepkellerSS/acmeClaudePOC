public with sharing class ACME_LeadScoreUpdater {
    @InvocableMethod(label='Update Lead Score')
    public static void updateLeadScores(List<Id> leadIds) {
        List<Lead> leadsToUpdate = [
            SELECT Id, NumberOfEmployees, Industry, Email, HasOptedOutOfEmail 
            FROM Lead 
            WHERE Id IN :leadIds
            WITH SECURITY_ENFORCED
        ];
        
        List<Lead> updatedLeads = new List<Lead>();
        
        for (Lead lead : leadsToUpdate) {
            Integer newScore = ACME_LeadScoringService.calculateLeadScore(lead);
            updatedLeads.add(new Lead(
                Id = lead.Id,
                ACME_Lead_Score__c = newScore,
                ACME_Last_Score_Calculation__c = System.now()
            ));
        }
        
        if (!updatedLeads.isEmpty()) {
            Database.update(updatedLeads, false);
        }
    }
}