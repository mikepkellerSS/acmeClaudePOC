/**
 * @description Stores and manages lead scoring criteria and weights
 * @author Studio Science
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringMetrics {
    
    // Demographic Scoring Weights
    private static final Integer COMPANY_SIZE_WEIGHT = 10;
    private static final Integer INDUSTRY_WEIGHT = 10;
    private static final Integer JOB_TITLE_WEIGHT = 10;
    private static final Integer LOCATION_WEIGHT = 10;
    
    // Engagement Scoring Weights
    private static final Integer WEBSITE_VISITS_WEIGHT = 15;
    private static final Integer EMAIL_OPENS_WEIGHT = 15;
    private static final Integer CONTENT_DOWNLOADS_WEIGHT = 15;
    private static final Integer SOCIAL_INTERACTIONS_WEIGHT = 15;
    
    /**
     * Retrieves scoring weights for demographic factors
     * @return Map of demographic scoring criteria
     */
    public static Map<String, Integer> getDemographicWeights() {
        return new Map<String, Integer>{
            'Company_Size' => COMPANY_SIZE_WEIGHT,
            'Industry' => INDUSTRY_WEIGHT,
            'Job_Title' => JOB_TITLE_WEIGHT,
            'Location' => LOCATION_WEIGHT
        };
    }
    
    /**
     * Retrieves scoring weights for engagement factors
     * @return Map of engagement scoring criteria
     */
    public static Map<String, Integer> getEngagementWeights() {
        return new Map<String, Integer>{
            'Website_Visits' => WEBSITE_VISITS_WEIGHT,
            'Email_Opens' => EMAIL_OPENS_WEIGHT,
            'Content_Downloads' => CONTENT_DOWNLOADS_WEIGHT,
            'Social_Interactions' => SOCIAL_INTERACTIONS_WEIGHT
        };
    }
}