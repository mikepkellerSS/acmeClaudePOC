/**
 * @description Core service for lead scoring calculations
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculates and updates lead score
     * @param leads List of leads to score
     */
    public static void calculateLeadScores(List<Lead> leads) {
        for (Lead lead : leads) {
            try {
                // Calculate demographic points
                Decimal demographicPoints = ACME_LeadScoringRules.calculateDemographicPoints(lead);
                lead.ACME_Demographic_Points__c = demographicPoints;
                
                // Calculate engagement points
                Decimal engagementPoints = ACME_LeadScoringRules.calculateEngagementPoints(lead);
                lead.ACME_Engagement_Points__c = engagementPoints;
                
                // Calculate total lead score
                Decimal totalScore = Math.min(
                    (demographicPoints * 0.5) + (engagementPoints * 0.5), 
                    100
                );
                
                lead.ACME_Lead_Score__c = totalScore;
                lead.ACME_Last_Score_Calculation__c = System.now();
            } catch (Exception e) {
                // Log error for individual lead
                System.Logger.error('Lead scoring error for lead ' + lead.Id + ': ' + e.getMessage());
            }
        }
    }
}