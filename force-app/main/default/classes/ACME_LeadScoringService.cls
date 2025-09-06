/**
 * Service class to orchestrate lead scoring process
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Process and update lead score
     * @param leads List of leads to score
     */
    public static void processLeadScores(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return;
        }
        
        // Bulk scoring process
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            if (canUpdateLead(lead)) {
                Integer calculatedScore = ACME_LeadScoreCalculator.calculateLeadScore(lead);
                
                lead.ACME_Lead_Score__c = calculatedScore;
                lead.ACME_Score_Last_Updated__c = System.now();
                
                leadsToUpdate.add(lead);
            }
        }
        
        // Perform update with proper security
        if (!leadsToUpdate.isEmpty() && 
            Schema.sObjectType.Lead.isUpdateable()) {
            update leadsToUpdate;
        }
    }
    
    /**
     * Check if lead can be updated
     * @param lead Lead to validate
     * @return Boolean indicating if lead can be updated
     */
    private static Boolean canUpdateLead(Lead lead) {
        return lead != null && 
               Schema.sObjectType.Lead.isUpdateable() && 
               Schema.sObjectType.Lead.fields.ACME_Lead_Score__c.isUpdateable();
    }
}