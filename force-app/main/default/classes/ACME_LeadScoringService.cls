/**
 * Service class for calculating lead scores
 * @author ACME Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringService {
    /**
     * Calculate lead scores for a list of leads
     * @param leads List of leads to score
     */
    public static void calculateLeadScores(List<Lead> leads) {
        for (Lead lead : leads) {
            // Validate input
            if (lead == null) continue;

            // Calculate individual score components
            Integer engagementScore = calculateEngagementScore(lead);
            Integer demographicScore = calculateDemographicScore(lead);

            // Compute composite lead score
            Decimal compositeScore = (engagementScore * ACME_LeadScoringConstants.ENGAGEMENT_WEIGHT) + 
                                      (demographicScore * ACME_LeadScoringConstants.DEMOGRAPHIC_WEIGHT);

            // Ensure score is within valid range
            lead.ACME_Lead_Score__c = Math.min(
                Math.max(compositeScore.intValue(), 
                         ACME_LeadScoringConstants.MIN_LEAD_SCORE), 
                ACME_LeadScoringConstants.MAX_LEAD_SCORE
            );

            // Update additional scoring fields
            lead.ACME_Engagement_Score__c = engagementScore;
            lead.ACME_Demographic_Score__c = demographicScore;
            lead.ACME_Last_Score_Calculation__c = System.now();
        }
    }

    /**
     * Calculate engagement score for a lead
     * @param lead Lead to evaluate
     * @return Engagement score
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer score = 0;

        // Email engagement
        if (lead.HasOptedOutOfEmail == false) {
            score += ACME_LeadScoringConstants.EMAIL_OPEN_POINTS;
        }

        // Website interactions
        if (lead.Website != null) {
            score += ACME_LeadScoringConstants.WEBSITE_VISIT_POINTS;
        }

        // Content download tracking (placeholder logic)
        // In real implementation, track actual content downloads
        score += ACME_LeadScoringConstants.CONTENT_DOWNLOAD_POINTS;

        return score;
    }

    /**
     * Calculate demographic score for a lead
     * @param lead Lead to evaluate
     * @return Demographic score
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer score = 0;

        // Company size scoring
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 100) {
            score += ACME_LeadScoringConstants.COMPANY_SIZE_POINTS;
        }

        // Industry matching
        if (lead.Industry != null) {
            score += ACME_LeadScoringConstants.INDUSTRY_MATCH_POINTS;
        }

        // Job title relevance
        if (lead.Title != null) {
            score += ACME_LeadScoringConstants.JOB_TITLE_POINTS;
        }

        return score;
    }
}