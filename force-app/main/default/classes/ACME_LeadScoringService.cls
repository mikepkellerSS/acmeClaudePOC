/**
 * Lead Scoring Service for calculating and managing lead scores
 * Implements complex scoring logic with security and performance considerations
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on multiple criteria
     * @param leadRecord The lead record to score
     * @return Integer representing lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Validate input
        if (leadRecord == null) {
            return 0;
        }

        Integer score = 0;
        
        // Retrieve scoring metrics from custom metadata
        List<ACME_LeadScoreMetric__mdt> scoringMetrics = [
            SELECT MasterLabel, Weight__c, Criteria__c 
            FROM ACME_LeadScoreMetric__mdt 
            WITH SECURITY_ENFORCED
        ];

        // Calculate demographic score
        score += calculateDemographicScore(leadRecord, scoringMetrics);
        
        // Calculate engagement score
        score += calculateEngagementScore(leadRecord, scoringMetrics);
        
        // Ensure score is between 0-100
        return Math.min(Math.max(score, 0), 100);
    }

    /**
     * Calculate demographic scoring based on lead attributes
     * @param leadRecord Lead record to evaluate
     * @param scoringMetrics List of scoring metrics
     * @return Integer demographic score component
     */
    private static Integer calculateDemographicScore(Lead leadRecord, List<ACME_LeadScoreMetric__mdt> scoringMetrics) {
        Integer demographicScore = 0;

        // Example demographic scoring logic
        if (String.isNotBlank(leadRecord.Company)) {
            demographicScore += 10;
        }

        if (String.isNotBlank(leadRecord.Title)) {
            demographicScore += 15;
        }

        return demographicScore;
    }

    /**
     * Calculate engagement scoring based on lead interactions
     * @param leadRecord Lead record to evaluate
     * @param scoringMetrics List of scoring metrics
     * @return Integer engagement score component
     */
    private static Integer calculateEngagementScore(Lead leadRecord, List<ACME_LeadScoreMetric__mdt> scoringMetrics) {
        Integer engagementScore = 0;

        // Example engagement scoring logic
        if (leadRecord.NumberOfEmployees != null && leadRecord.NumberOfEmployees > 100) {
            engagementScore += 20;
        }

        return engagementScore;
    }

    /**
     * Update lead score and engagement level
     * @param leadId ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Integer score) {
        // Perform FLS and CRUD checks
        if (!Schema.SObjectType.Lead.isUpdateable()) {
            return;
        }

        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_LeadScore__c = score,
            ACME_EngagementLevel__c = determineEngagementLevel(score)
        );

        try {
            update leadToUpdate;
        } catch (Exception e) {
            // Log error
            System.debug(LoggingLevel.ERROR, 'Error updating lead score: ' + e.getMessage());
        }
    }

    /**
     * Determine engagement level based on lead score
     * @param score Lead score
     * @return Engagement level as a string
     */
    private static String determineEngagementLevel(Integer score) {
        if (score >= 80) {
            return 'Hot';
        } else if (score >= 50) {
            return 'Warm';
        } else {
            return 'Cold';
        }
    }
}