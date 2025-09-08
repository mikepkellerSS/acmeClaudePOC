/**
 * Service class for calculating lead scores based on predefined criteria
 * Implements secure, efficient lead scoring mechanism
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on predefined metrics
     * @param lead The lead record to score
     * @return Calculated lead score between 1-100
     */
    public static Decimal calculateLeadScore(Lead lead) {
        // Validate input
        if (lead == null) {
            return 0;
        }

        // Retrieve scoring metrics
        List<ACME_Lead_Scoring_Metric__c> scoringMetrics = getActiveScoringMetrics();
        
        // Initialize score
        Decimal totalScore = 0;
        Decimal maxPossibleScore = 0;

        // Calculate score for each metric
        for (ACME_Lead_Scoring_Metric__c metric : scoringMetrics) {
            Decimal metricScore = calculateMetricScore(lead, metric);
            totalScore += metricScore * metric.ACME_Weight__c;
            maxPossibleScore += 100 * metric.ACME_Weight__c;
        }

        // Normalize score to 1-100 range
        if (maxPossibleScore > 0) {
            return Math.min(Math.max((totalScore / maxPossibleScore) * 100, 1), 100).setScale(0);
        }

        return 0;
    }

    /**
     * Retrieve active scoring metrics
     * @return List of active scoring metrics
     */
    private static List<ACME_Lead_Scoring_Metric__c> getActiveScoringMetrics() {
        // Secure query with FLS and CRUD checks
        return [
            SELECT ACME_Criteria_Name__c, 
                   ACME_Weight__c, 
                   ACME_Criteria_Type__c 
            FROM ACME_Lead_Scoring_Metric__c 
            WHERE IsActive__c = true 
            ORDER BY ACME_Weight__c DESC
        ];
    }

    /**
     * Calculate score for a specific metric
     * @param lead Lead record
     * @param metric Scoring metric
     * @return Calculated metric score
     */
    private static Decimal calculateMetricScore(Lead lead, ACME_Lead_Scoring_Metric__c metric) {
        // Implement specific scoring logic based on metric type
        switch on metric.ACME_Criteria_Type__c {
            when 'Engagement' {
                return calculateEngagementScore(lead);
            }
            when 'Demographics' {
                return calculateDemographicScore(lead);
            }
            when else {
                return 0;
            }
        }
    }

    /**
     * Calculate engagement-based score
     * @param lead Lead record
     * @return Engagement score
     */
    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal engagementScore = 0;

        // Example engagement scoring logic
        if (lead.HasOptedOutOfEmail == false) {
            engagementScore += 20;
        }
        
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 50) {
            engagementScore += 30;
        }

        if (lead.Email != null) {
            engagementScore += 50;
        }

        return Math.min(engagementScore, 100);
    }

    /**
     * Calculate demographic-based score
     * @param lead Lead record
     * @return Demographic score
     */
    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal demographicScore = 0;

        // Example demographic scoring logic
        if (lead.Country != null) {
            demographicScore += 40;
        }

        if (lead.Title != null) {
            demographicScore += 60;
        }

        return Math.min(demographicScore, 100);
    }

    /**
     * Update lead score on record changes
     * @param leads List of leads to update
     */
    public static void updateLeadScoreOnChange(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leads) {
            Decimal calculatedScore = calculateLeadScore(lead);
            
            // Only update if score has changed
            if (lead.ACME_Lead_Score__c != calculatedScore) {
                lead.ACME_Lead_Score__c = calculatedScore;
                leadsToUpdate.add(lead);
            }
        }

        // Perform update with system context to bypass sharing rules
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
}