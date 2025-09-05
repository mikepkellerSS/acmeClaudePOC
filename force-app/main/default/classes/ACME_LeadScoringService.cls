/**
 * Service class for calculating lead scores based on engagement and demographics
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographics
     * 
     * @param leadRecord Lead record to score
     * @return Integer score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Ensure we have read access to lead fields
        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new System.NoAccessException('No access to Lead object');
        }

        Integer score = 0;
        
        // Scoring logic with explicit null checks
        if (String.isNotBlank(leadRecord.Email)) {
            score += 20;
        }
        
        if (String.isNotBlank(leadRecord.Company)) {
            score += 15;
        }
        
        if (leadRecord.LeadSource == 'Marketing Campaign') {
            score += 25;
        }
        
        // Limit score between 0-100
        return Math.min(Math.max(score, 0), 100);
    }

    /**
     * Bulk lead scoring method for batch processing
     * 
     * @param leads List of leads to score
     * @return List of scored leads
     */
    public static List<Lead> scoreBulkLeads(List<Lead> leads) {
        List<Lead> scoredLeads = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            lead.ACME_Lead_Score__c = score;
            lead.ACME_Last_Scored_Date__c = System.now();
            scoredLeads.add(lead);
        }
        
        return scoredLeads;
    }
}