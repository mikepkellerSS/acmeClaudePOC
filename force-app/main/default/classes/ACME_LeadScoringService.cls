/**
 * @description Lead scoring service for prioritizing and calculating lead scores
 * @author Studio Science
 * @date 2025-09-09
 */
public with sharing class ACME_LeadScoringService {
    
    @TestVisible
    private static final Integer MAX_SCORE = 100;

    /**
     * Calculate lead score based on multiple criteria
     * @param lead Lead record to score
     * @return Integer score between 0-100
     */
    public static Integer calculateLeadScore(Lead lead) {
        if (lead == null) {
            return 0;
        }

        Integer score = 0;

        // Company Size Scoring (0-30 points)
        score += calculateCompanySizeScore(lead);

        // Engagement Level Scoring (0-40 points)
        score += calculateEngagementScore(lead);

        // Demographics Scoring (0-30 points)
        score += calculateDemographicScore(lead);

        // Ensure score is within 0-100 range
        return Math.min(Math.max(score, 0), MAX_SCORE);
    }

    /**
     * Calculate score based on company size
     * @param lead Lead record
     * @return Integer score for company size
     */
    private static Integer calculateCompanySizeScore(Lead lead) {
        if (lead.NumberOfEmployees == null) {
            return 0;
        }

        Integer employees = lead.NumberOfEmployees;
        if (employees <= 10) {
            return 10;
        } else if (employees <= 50) {
            return 20;
        } else if (employees <= 200) {
            return 25;
        } else {
            return 30;
        }
    }

    /**
     * Calculate score based on engagement level
     * @param lead Lead record
     * @return Integer score for engagement
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;

        // Email engagement
        if (lead.HasOptedOutOfEmail == false) {
            engagementScore += 10;
        }

        // Web activity or campaign response
        if (lead.LeadSource != null) {
            engagementScore += 15;
        }

        // Additional engagement metrics can be added here
        return Math.min(engagementScore, 40);
    }

    /**
     * Calculate score based on demographic information
     * @param lead Lead record
     * @return Integer score for demographics
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;

        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            demographicScore += 15;
        }

        // Job title scoring
        if (String.isNotBlank(lead.Title)) {
            demographicScore += 15;
        }

        return Math.min(demographicScore, 30);
    }

    /**
     * Update lead score and timestamp
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return;
        }

        for (Lead lead : leads) {
            lead.ACME_Lead_Score__c = calculateLeadScore(lead);
            lead.ACME_Last_Score_Calculation__c = System.now();
        }

        // Perform update with system context to bypass sharing rules
        Database.update(leads, false);
    }
}