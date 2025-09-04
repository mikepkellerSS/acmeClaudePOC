/**
 * Service class to manage the lead scoring model.
 * Scores leads based on engagement and demographic criteria.
 */
public with sharing class ACME_LeadScoreService {
    
    /**
     * Calculates the lead score based on the given lead.
     * @param lead The lead to calculate the score for.
     * @return The calculated lead score (1-100).
     */
    public static Integer calculateLeadScore(Lead lead) {
        Integer score = 0;
        
        // Score based on engagement criteria
        score += getEngagementScore(lead);
        
        // Score based on demographic criteria
        score += getDemographicScore(lead);
        
        // Ensure the score is between 1 and 100
        score = Math.max(1, Math.min(100, score));
        
        return score;
    }
    
    /**
     * Calculates the engagement score for the given lead.
     * @param lead The lead to calculate the engagement score for.
     * @return The engagement score (0-50).
     */
    private static Integer getEngagementScore(Lead lead) {
        Integer score = 0;
        
        // Score based on number of website visits
        if (lead.Website_Visits__c != null) {
            score += (Integer) Math.round(lead.Website_Visits__c / 5);
        }
        
        // Score based on number of email opens
        if (lead.Email_Opens__c != null) {
            score += (Integer) Math.round(lead.Email_Opens__c / 2);
        }
        
        // Score based on number of email clicks
        if (lead.Email_Clicks__c != null) {
            score += (Integer) Math.round(lead.Email_Clicks__c);
        }
        
        return Math.min(50, score);
    }
    
    /**
     * Calculates the demographic score for the given lead.
     * @param lead The lead to calculate the demographic score for.
     * @return The demographic score (0-50).
     */
    private static Integer getDemographicScore(Lead lead) {
        Integer score = 0;
        
        // Score based on industry
        if (lead.Industry != null) {
            List<ScorecardMetric__c> metrics = [
                SELECT Industry__c, Score__c
                FROM ScorecardMetric__c
                WHERE Industry__c = :lead.Industry
                LIMIT 1
            ];
            if (!metrics.isEmpty()) {
                score += metrics[0].Score__c;
            }
        }
        
        // Score based on job title
        if (lead.Title != null) {
            List<ScorecardMetric__c> metrics = [
                SELECT Job_Title__c, Score__c
                FROM ScorecardMetric__c
                WHERE Job_Title__c = :lead.Title
                LIMIT 1
            ];
            if (!metrics.isEmpty()) {
                score += metrics[0].Score__c;
            }
        }
        
        // Score based on annual revenue
        if (lead.AnnualRevenue != null) {
            List<ScorecardMetric__c> metrics = [
                SELECT Annual_Revenue__c, Score__c
                FROM ScorecardMetric__c
                WHERE Annual_Revenue__c = :lead.AnnualRevenue
                LIMIT 1
            ];
            if (!metrics.isEmpty()) {
                score += metrics[0].Score__c;
            }
        }
        
        return Math.min(50, score);
    }
    
    /**
     * Updates the lead score on the given lead.
     * @param lead The lead to update the score for.
     */
    public static void updateLeadScore(Lead lead) {
        Integer score = calculateLeadScore(lead);
        lead.Lead_Score__c = score;
        update lead WITH SECURITY_ENFORCED;
    }
}