/**
 * Service class for calculating lead scores based on engagement and demographic criteria
 * @author ACME Development Team
 * @date 2024-02-15
 * @description Handles lead scoring calculation logic
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate the overall lead score based on engagement and demographic factors
     * @param leadRecord The lead record to score
     * @return Integer representing the calculated lead score (0-100)
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        if (leadRecord == null) {
            return 0;
        }

        Integer engagementScore = calculateEngagementScore(leadRecord);
        Integer demographicScore = calculateDemographicScore(leadRecord);
        
        // Weighted calculation with 60% engagement, 40% demographic
        Integer totalScore = Math.round(
            (engagementScore * 0.6 + demographicScore * 0.4)
        );
        
        return Math.min(Math.max(totalScore, 0), 100);
    }

    /**
     * Calculate engagement score based on lead interaction metrics
     * @param lead The lead record to evaluate
     * @return Integer representing engagement score
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer score = 0;
        
        // Engagement scoring criteria
        if (lead.Email != null) {
            score += 20;
        }
        
        if (lead.HasOptedOutOfEmail == false) {
            score += 10;
        }
        
        // Additional engagement metrics can be added here
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 0) {
            score += 15;
        }
        
        return Math.min(score, 100);
    }

    /**
     * Calculate demographic score based on lead profile information
     * @param lead The lead record to evaluate
     * @return Integer representing demographic score
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer score = 0;
        
        // Demographic scoring criteria
        if (lead.Company != null) {
            score += 30;
        }
        
        if (lead.Title != null) {
            score += 20;
        }
        
        // Industry-based scoring
        if (lead.Industry != null) {
            score += 15;
        }
        
        return Math.min(score, 100);
    }

    /**
     * Update lead scores in bulk
     * @param leads List of leads to update with scores
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer leadScore = calculateLeadScore(lead);
            
            lead.ACME_Lead_Score__c = leadScore;
            lead.ACME_Last_Score_Calculation__c = System.now();
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
            } catch (DMLException e) {
                // Log error or handle appropriately
                System.debug('Error updating lead scores: ' + e.getMessage());
            }
        }
    }
}