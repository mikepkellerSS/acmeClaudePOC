/**
 * @description Lead Scoring Service for calculating and managing lead scores
 * Implements complex scoring logic with security and performance considerations
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographic metrics
     * @param leadRecord Lead record to be scored
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        if (leadRecord == null) {
            return 0;
        }

        Integer engagementScore = calculateEngagementScore(leadRecord);
        Integer demographicScore = calculateDemographicScore(leadRecord);
        
        return Math.min(100, Math.max(0, 
            (Integer)((engagementScore * 0.6) + (demographicScore * 0.4))
        ));
    }

    /**
     * Calculate engagement score based on lead interactions
     * @param leadRecord Lead record for scoring
     * @return Integer engagement score
     */
    private static Integer calculateEngagementScore(Lead leadRecord) {
        Integer score = 0;
        
        // Example engagement scoring logic
        if (leadRecord.NumberOfEmployees != null && leadRecord.NumberOfEmployees > 100) {
            score += 20;
        }
        
        if (leadRecord.Email != null) {
            score += 30;
        }
        
        return score;
    }

    /**
     * Calculate demographic score based on lead attributes
     * @param leadRecord Lead record for scoring
     * @return Integer demographic score
     */
    private static Integer calculateDemographicScore(Lead leadRecord) {
        Integer score = 0;
        
        // Example demographic scoring logic
        if (leadRecord.Industry != null) {
            score += 25;
        }
        
        if (leadRecord.Country != null) {
            score += 25;
        }
        
        return score;
    }

    /**
     * Update lead score and trigger platform event
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            lead.ACME_Lead_Score__c = score;
            lead.ACME_Last_Scored_Date__c = System.now();
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}