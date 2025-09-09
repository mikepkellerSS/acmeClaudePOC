/**
 * @description Lead scoring service for calculating lead engagement scores
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on predefined metrics
     * @param leadRecord Lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Retrieve scoring metrics
        List<ACME_Lead_Scoring_Metric__c> scoringMetrics = [
            SELECT Name, Weight__c, Criteria_Type__c, Min_Value__c, Max_Value__c 
            FROM ACME_Lead_Scoring_Metric__c
        ];
        
        Integer totalScore = 0;
        
        // Process each scoring metric
        for (ACME_Lead_Scoring_Metric__c metric : scoringMetrics) {
            Decimal metricScore = calculateMetricScore(leadRecord, metric);
            totalScore += Integer.valueOf(metricScore * (metric.Weight__c / 100));
        }
        
        // Ensure score is between 0-100
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
    /**
     * Calculate individual metric score
     * @param leadRecord Lead record
     * @param metric Scoring metric
     * @return Decimal metric-specific score
     */
    private static Decimal calculateMetricScore(Lead leadRecord, ACME_Lead_Scoring_Metric__c metric) {
        // Implement specific scoring logic based on metric type
        if (metric.Criteria_Type__c == 'Engagement') {
            return calculateEngagementScore(leadRecord, metric);
        } else if (metric.Criteria_Type__c == 'Demographics') {
            return calculateDemographicScore(leadRecord, metric);
        }
        
        return 0;
    }
    
    /**
     * Calculate engagement-based score
     * @param leadRecord Lead record
     * @param metric Engagement scoring metric
     * @return Decimal engagement score
     */
    private static Decimal calculateEngagementScore(Lead leadRecord, ACME_Lead_Scoring_Metric__c metric) {
        // Example engagement scoring (customize as needed)
        Integer emailInteractions = leadRecord.NumberOfEmailInteractions__c != null 
            ? Integer.valueOf(leadRecord.NumberOfEmailInteractions__c) : 0;
        
        if (emailInteractions >= metric.Max_Value__c) {
            return 1.0;
        } else if (emailInteractions <= metric.Min_Value__c) {
            return 0.0;
        }
        
        return (emailInteractions - metric.Min_Value__c) / 
               (metric.Max_Value__c - metric.Min_Value__c);
    }
    
    /**
     * Calculate demographic-based score
     * @param leadRecord Lead record
     * @param metric Demographic scoring metric
     * @return Decimal demographic score
     */
    private static Decimal calculateDemographicScore(Lead leadRecord, ACME_Lead_Scoring_Metric__c metric) {
        // Example demographic scoring (customize as needed)
        if (String.isNotBlank(leadRecord.Title)) {
            return 1.0;
        }
        
        return 0.0;
    }
    
    /**
     * Update lead score
     * @param leadId ID of lead to update
     */
    public static void updateLeadScore(Id leadId) {
        Lead leadToUpdate = [
            SELECT Id, ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id = :leadId
        ];
        
        Integer newScore = calculateLeadScore(leadToUpdate);
        
        leadToUpdate.ACME_Lead_Score__c = newScore;
        leadToUpdate.ACME_Last_Scored_Date__c = System.now();
        
        update leadToUpdate;
    }
}