/**
 * @description Service class for calculating and managing lead scoring logic
 * @author Studio Science
 * @date 2025-09-05
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * @description Calculates lead scores based on predefined criteria
     * @param leads List of leads to be scored
     */
    public static void calculateLeadScore(List<Lead> leads) {
        // Validate input
        if (leads == null || leads.isEmpty()) {
            return;
        }

        // Perform security checks
        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new System.NoAccessException('Insufficient lead object access');
        }

        // Core scoring logic
        for (Lead lead : leads) {
            Integer score = calculateIndividualLeadScore(lead);
            
            // Update lead score with security checks
            if (Schema.sObjectType.Lead.fields.ACME_Lead_Score__c.isUpdateable()) {
                lead.ACME_Lead_Score__c = score;
            }
        }
    }

    /**
     * @description Calculates individual lead score based on multiple factors
     * @param lead Individual lead to be scored
     * @return Integer representing lead score (0-100)
     */
    private static Integer calculateIndividualLeadScore(Lead lead) {
        Integer score = 0;

        // Demographic scoring
        score += calculateDemographicScore(lead);

        // Engagement scoring
        score += calculateEngagementScore(lead);

        // Ensure score is within 0-100 range
        return Math.min(Math.max(score, 0), 100);
    }

    /**
     * @description Calculates demographic-based lead score
     * @param lead Lead to evaluate
     * @return Integer demographic score component
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;

        // Example demographic scoring logic
        if (String.isNotBlank(lead.Company)) {
            demographicScore += 20;
        }

        if (String.isNotBlank(lead.Title)) {
            demographicScore += 15;
        }

        return demographicScore;
    }

    /**
     * @description Calculates engagement-based lead score
     * @param lead Lead to evaluate
     * @return Integer engagement score component
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;

        // Example engagement scoring logic
        if (lead.ACME_Engagement_Frequency__c != null) {
            engagementScore += Math.min(lead.ACME_Engagement_Frequency__c.intValue() * 5, 30);
        }

        return engagementScore;
    }
}