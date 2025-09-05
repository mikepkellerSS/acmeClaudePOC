/**
 * Service class for lead scoring calculations and management
 * Implements secure, modular lead scoring logic
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on predefined criteria
     * @param lead The lead to score
     * @return Calculated lead score
     */
    public static Decimal calculateLeadScore(Lead lead) {
        Decimal engagementPoints = calculateEngagementPoints(lead);
        Decimal demographicPoints = calculateDemographicPoints(lead);
        
        Decimal totalScore = engagementPoints + demographicPoints;
        totalScore = Math.min(Math.max(totalScore, 0), 100);
        
        return totalScore;
    }
    
    /**
     * Calculate engagement points for a lead
     * @param lead The lead to evaluate
     * @return Engagement points
     */
    private static Decimal calculateEngagementPoints(Lead lead) {
        Decimal points = 0;
        
        // Example engagement scoring logic
        if (lead.HasOptedOutOfEmail == false) {
            points += 10;
        }
        
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 50) {
            points += 20;
        }
        
        return points;
    }
    
    /**
     * Calculate demographic points for a lead
     * @param lead The lead to evaluate
     * @return Demographic points
     */
    private static Decimal calculateDemographicPoints(Lead lead) {
        Decimal points = 0;
        
        // Example demographic scoring logic
        if (String.isNotBlank(lead.Title)) {
            points += 15;
        }
        
        if (String.isNotBlank(lead.Company)) {
            points += 15;
        }
        
        return points;
    }
    
    /**
     * Update lead score and related fields
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            if (Schema.SObjectType.Lead.fields.ACME_Lead_Score__c.isUpdateable()) {
                lead.ACME_Lead_Score__c = calculateLeadScore(lead);
                lead.ACME_Lead_Score_Last_Updated__c = System.now();
                leadsToUpdate.add(lead);
            }
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}