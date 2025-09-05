/**
 * @description Lead scoring calculation service
 * @author Studio Science
 * @date 2025-09-05
 */
public with sharing class ACME_LeadScoringService {
    
    // Custom Metadata Type for Scoring Rules
    private static final String SCORING_METADATA_TYPE = 'Lead_Scoring_Rule__mdt';
    
    /**
     * Calculate lead score based on engagement and demographic factors
     * @param lead Input lead record
     * @return Calculated lead score
     */
    public static Decimal calculateLeadScore(Lead lead) {
        Decimal engagementScore = calculateEngagementScore(lead);
        Decimal demographicScore = calculateDemographicScore(lead);
        
        Decimal totalScore = engagementScore + demographicScore;
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
    /**
     * Calculate engagement score based on lead interactions
     * @param lead Input lead record
     * @return Engagement score
     */
    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal score = 0;
        
        // Example scoring logic - customize as needed
        if (lead.Email != null) score += 20;
        if (lead.HasOptedOutOfEmail == false) score += 10;
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 50) score += 15;
        
        return score;
    }
    
    /**
     * Calculate demographic score based on lead attributes
     * @param lead Input lead record
     * @return Demographic score
     */
    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal score = 0;
        
        // Example scoring logic - customize as needed
        if (lead.Title != null) score += 15;
        if (lead.Industry != null) score += 20;
        if (lead.Country != null) score += 10;
        
        return score;
    }
    
    /**
     * Update lead score
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Decimal score = calculateLeadScore(lead);
            
            lead.ACME_Lead_Score__c = score;
            lead.ACME_Engagement_Score__c = calculateEngagementScore(lead);
            lead.ACME_Demographic_Score__c = calculateDemographicScore(lead);
            lead.ACME_Last_Score_Calculation__c = System.now();
            
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}