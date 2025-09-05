/**
 * Constants and configuration for Lead Scoring Implementation
 * @author ACME Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringConstants {
    // Scoring Weight Constants
    public static final Decimal ENGAGEMENT_WEIGHT = 0.6;
    public static final Decimal DEMOGRAPHIC_WEIGHT = 0.4;

    // Scoring Thresholds
    public static final Integer MAX_LEAD_SCORE = 100;
    public static final Integer MIN_LEAD_SCORE = 0;

    // Engagement Score Factors
    public static final Integer EMAIL_OPEN_POINTS = 5;
    public static final Integer WEBSITE_VISIT_POINTS = 3;
    public static final Integer CONTENT_DOWNLOAD_POINTS = 10;

    // Demographic Score Factors
    public static final Integer COMPANY_SIZE_POINTS = 15;
    public static final Integer INDUSTRY_MATCH_POINTS = 20;
    public static final Integer JOB_TITLE_POINTS = 10;

    // Scoring Categories
    public enum LeadScoreCategory {
        COLD,
        WARM,
        HOT
    }

    /**
     * Determines Lead Score Category based on numeric score
     * @param score Numeric lead score
     * @return LeadScoreCategory enum value
     */
    public static LeadScoreCategory getScoreCategory(Decimal score) {
        if (score >= 80) return LeadScoreCategory.HOT;
        if (score >= 50) return LeadScoreCategory.WARM;
        return LeadScoreCategory.COLD;
    }
}