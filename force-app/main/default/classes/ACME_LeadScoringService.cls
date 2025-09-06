/**
 * @description Lead scoring service for calculating and updating lead scores
 * @author Studio Science
 * @date 2025-09-06
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on multiple criteria
     * @param leads List of leads to score
     */
    public static void calculateLeadScore(List<Lead> leads) {
        // Validate input
        if (leads == null || leads.isEmpty()) {
            return;
        }

        // Retrieve scoring criteria from custom metadata
        List<ACME_Scoring_Criteria__mdt> scoringCriteria = 
            [SELECT Label, Score_Weight__c, Criteria_Type__c, Minimum_Threshold__c 
             FROM ACME_Scoring_Criteria__mdt 
             WHERE IsActive__c = true];

        // Process each lead
        for (Lead lead : leads) {
            Decimal totalScore = 0;

            // Calculate demographic score
            Decimal demographicScore = calculateDemographicScore(lead, scoringCriteria);
            
            // Calculate engagement score
            Decimal engagementScore = calculateEngagementScore(lead, scoringCriteria);

            // Combine scores
            totalScore = demographicScore + engagementScore;

            // Ensure score is within 0-100 range
            lead.ACME_Lead_Score__c = Math.min(Math.max(totalScore, 0), 100);
        }
    }

    /**
     * Calculate demographic score for a lead
     * @param lead Individual lead to score
     * @param scoringCriteria List of scoring criteria
     * @return Demographic score
     */
    private static Decimal calculateDemographicScore(Lead lead, List<ACME_Scoring_Criteria__mdt> scoringCriteria) {
        Decimal demographicScore = 0;

        for (ACME_Scoring_Criteria__mdt criteria : scoringCriteria) {
            if (criteria.Criteria_Type__c == 'DEMOGRAPHIC') {
                // Add specific demographic scoring logic here
                if (lead.Company != null && lead.Company.length() > 0) {
                    demographicScore += criteria.Score_Weight__c;
                }
                // Add more demographic scoring conditions
            }
        }

        return demographicScore;
    }

    /**
     * Calculate engagement score for a lead
     * @param lead Individual lead to score
     * @param scoringCriteria List of scoring criteria
     * @return Engagement score
     */
    private static Decimal calculateEngagementScore(Lead lead, List<ACME_Scoring_Criteria__mdt> scoringCriteria) {
        Decimal engagementScore = 0;

        for (ACME_Scoring_Criteria__mdt criteria : scoringCriteria) {
            if (criteria.Criteria_Type__c == 'ENGAGEMENT') {
                // Add specific engagement scoring logic
                if (lead.ACME_Last_Engagement_Date__c != null) {
                    Integer daysSinceLastEngagement = lead.ACME_Last_Engagement_Date__c.daysBetween(System.today());
                    if (daysSinceLastEngagement <= 30) {
                        engagementScore += criteria.Score_Weight__c;
                    }
                }
            }
        }

        return engagementScore;
    }
}