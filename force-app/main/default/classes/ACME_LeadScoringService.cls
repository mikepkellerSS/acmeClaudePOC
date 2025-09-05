/**
 * @description Lead scoring calculation service for comprehensive lead evaluation
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on demographic and engagement criteria
     * @param leadRecord Lead record to be scored
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Validate input
        if (leadRecord == null) {
            return 0;
        }

        // Retrieve scoring criteria from custom metadata
        List<ACME_Scoring_Criteria__mdt> scoringCriteria = 
            [SELECT DeveloperName, Weight__c, Threshold__c 
             FROM ACME_Scoring_Criteria__mdt 
             WITH SECURITY_ENFORCED];

        Integer demographicScore = calculateDemographicScore(leadRecord, scoringCriteria);
        Integer engagementScore = calculateEngagementScore(leadRecord, scoringCriteria);

        // Combine scores with weighted calculation
        Integer totalScore = Math.min(Math.max(
            (demographicScore * 40 + engagementScore * 60) / 100, 
            0), 100);

        return totalScore;
    }

    /**
     * Calculate demographic score for lead
     * @param leadRecord Lead record
     * @param scoringCriteria List of scoring criteria
     * @return Integer demographic score
     */
    private static Integer calculateDemographicScore(
        Lead leadRecord, 
        List<ACME_Scoring_Criteria__mdt> scoringCriteria
    ) {
        Integer demographicScore = 0;

        // Company size scoring
        if (leadRecord.NumberOfEmployees != null) {
            demographicScore += evaluateCompanySize(
                leadRecord.NumberOfEmployees, 
                scoringCriteria
            );
        }

        // Industry scoring
        if (String.isNotBlank(leadRecord.Industry)) {
            demographicScore += evaluateIndustry(
                leadRecord.Industry, 
                scoringCriteria
            );
        }

        return Math.min(demographicScore, 100);
    }

    /**
     * Calculate engagement score for lead
     * @param leadRecord Lead record
     * @param scoringCriteria List of scoring criteria
     * @return Integer engagement score
     */
    private static Integer calculateEngagementScore(
        Lead leadRecord, 
        List<ACME_Scoring_Criteria__mdt> scoringCriteria
    ) {
        Integer engagementScore = 0;

        // Website visits scoring
        engagementScore += evaluateWebsiteVisits(
            leadRecord.Website_Visits__c, 
            scoringCriteria
        );

        // Email interactions scoring
        engagementScore += evaluateEmailInteractions(
            leadRecord.Email_Interactions__c, 
            scoringCriteria
        );

        return Math.min(engagementScore, 100);
    }

    // Additional private helper methods for specific scoring evaluations
    // (Implementations would be similar to the scoring logic demonstrated)
}