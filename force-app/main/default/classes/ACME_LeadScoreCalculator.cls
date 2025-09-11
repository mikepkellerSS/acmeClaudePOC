/**
 * @description Lead Score Calculator for Acme Corp
 * Calculates lead scores based on engagement and demographic criteria
 * @author Salesforce Architect
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoreCalculator {
    private static final Integer MAX_LEAD_SCORE = 100;
    private static final Integer MIN_LEAD_SCORE = 0;

    /**
     * Calculate lead score based on multiple criteria
     * @param lead Lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead lead) {
        Integer totalScore = 0;

        // Demographic Score Calculation
        totalScore += calculateDemographicScore(lead);

        // Engagement Score Calculation
        totalScore += calculateEngagementScore(lead);

        // Ensure score is within 0-100 range
        return Math.min(Math.max(totalScore, MIN_LEAD_SCORE), MAX_LEAD_SCORE);
    }

    /**
     * Calculate demographic score based on company size, industry, etc.
     * @param lead Lead record
     * @return Integer demographic score component
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;

        // Company Size Score
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees >= 500) {
                demographicScore += 30;
            } else if (lead.NumberOfEmployees >= 100) {
                demographicScore += 20;
            } else if (lead.NumberOfEmployees >= 50) {
                demographicScore += 10;
            }
        }

        // Industry Score
        List<String> targetIndustries = new List<String>{'Technology', 'Finance', 'Healthcare'};
        if (lead.Industry != null && targetIndustries.contains(lead.Industry)) {
            demographicScore += 20;
        }

        return demographicScore;
    }

    /**
     * Calculate engagement score based on interactions
     * @param lead Lead record
     * @return Integer engagement score component
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;

        // Email Engagement
        if (lead.HasOptedOutOfEmail == false) {
            engagementScore += 10;
        }

        // Web Activity Score
        if (lead.ACME__Web_Visits__c != null) {
            engagementScore += Math.min(lead.ACME__Web_Visits__c * 2, 30);
        }

        // Campaign Response
        if (lead.ACME__Campaign_Responses__c != null) {
            engagementScore += Math.min(lead.ACME__Campaign_Responses__c * 5, 40);
        }

        return engagementScore;
    }
}