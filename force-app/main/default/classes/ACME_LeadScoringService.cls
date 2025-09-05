/**
 * Service class for calculating lead scores based on predefined metrics
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculates the lead score based on active scoring metrics
     * @param lead The lead record to score
     * @return Integer representing the calculated lead score
     */
    public static Integer calculateLeadScore(Lead lead) {
        // Check for read access to Lead Scoring Metrics
        if (!Schema.SObjectType.ACME_Lead_Scoring_Metric__c.isAccessible()) {
            throw new System.NoAccessException('No access to Lead Scoring Metrics');
        }

        // Retrieve active scoring metrics
        List<ACME_Lead_Scoring_Metric__c> metrics = [
            SELECT Name__c, Weight__c, Category__c 
            FROM ACME_Lead_Scoring_Metric__c 
            WHERE Active__c = true 
            WITH SECURITY_ENFORCED
        ];
        
        Integer totalScore = 0;
        
        // Calculate score based on metrics
        for (ACME_Lead_Scoring_Metric__c metric : metrics) {
            // Apply scoring logic per metric
            totalScore += calculateMetricScore(lead, metric);
        }
        
        // Ensure score is between 1-100
        return Math.min(Math.max(totalScore, 1), 100);
    }

    /**
     * Calculates score for a specific metric
     * @param lead The lead record
     * @param metric The scoring metric to apply
     * @return Integer score for the specific metric
     */
    private static Integer calculateMetricScore(Lead lead, ACME_Lead_Scoring_Metric__c metric) {
        Integer metricScore = 0;

        // Example scoring logic - customize as needed
        if (metric.Category__c == 'Engagement') {
            if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 100) {
                metricScore += metric.Weight__c.intValue();
            }
        } else if (metric.Category__c == 'Demographics') {
            if (String.isNotBlank(lead.LeadSource)) {
                metricScore += metric.Weight__c.intValue();
            }
        }

        return metricScore;
    }

    /**
     * Bulk update lead scores
     * @param leads List of leads to update with scores
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();

        // Check for update access to Lead object
        if (!Schema.SObjectType.Lead.isUpdateable()) {
            throw new System.NoAccessException('No update access to Lead object');
        }

        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            
            // Only create update if score is different
            if (lead.ACME_Lead_Score__c != score) {
                lead.ACME_Lead_Score__c = score;
                leadsToUpdate.add(lead);
            }
        }

        // Perform bulk update
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}