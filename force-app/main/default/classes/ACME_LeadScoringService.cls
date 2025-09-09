/**
 * @description Lead scoring calculation service for ACME organization
 * @author Studio Science
 * @date 2025-09-09
 */
public with sharing class ACME_LeadScoringService {
    
    // Constants for scoring weights
    private static final Integer ENGAGEMENT_WEIGHT = 60;
    private static final Integer DEMOGRAPHIC_WEIGHT = 40;
    
    /**
     * Calculate lead score based on engagement and demographic factors
     * @param leadRecord Lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        try {
            Integer engagementPoints = calculateEngagementScore(leadRecord);
            Integer demographicPoints = calculateDemographicScore(leadRecord);
            
            Integer totalScore = Math.min(100, Math.max(0, 
                (engagementPoints * ENGAGEMENT_WEIGHT / 100) + 
                (demographicPoints * DEMOGRAPHIC_WEIGHT / 100)
            ));
            
            return totalScore;
        } catch (Exception e) {
            // Log the error and return a default score
            ACME_LeadScoreLogger.logError('Lead Scoring Error', e);
            return 0;
        }
    }
    
    /**
     * Calculate engagement score based on lead interactions
     * @param lead Lead record to evaluate
     * @return Integer engagement points
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;
        
        // Website interactions
        if (lead.Website != null) {
            engagementScore += 10;
        }
        
        // Email engagement
        if (lead.HasOptedOutOfEmail == false) {
            engagementScore += 20;
        }
        
        // Social media presence
        if (lead.LeadSource == 'Social Media') {
            engagementScore += 15;
        }
        
        return Math.min(50, engagementScore);
    }
    
    /**
     * Calculate demographic score based on lead attributes
     * @param lead Lead record to evaluate
     * @return Integer demographic points
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;
        
        // Company size scoring
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees >= 500) {
                demographicScore += 25;
            } else if (lead.NumberOfEmployees >= 100) {
                demographicScore += 15;
            } else if (lead.NumberOfEmployees >= 50) {
                demographicScore += 10;
            }
        }
        
        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            demographicScore += 15;
        }
        
        return Math.min(50, demographicScore);
    }
    
    /**
     * Update lead score and related fields
     * @param leadId ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Integer score) {
        try {
            Lead leadToUpdate = new Lead(
                Id = leadId,
                ACME_Lead_Score__c = score,
                ACME_Score_Last_Updated__c = System.now(),
                ACME_Engagement_Points__c = calculateEngagementScore(
                    [SELECT Id, Website, HasOptedOutOfEmail, LeadSource 
                     FROM Lead 
                     WHERE Id = :leadId 
                     WITH SECURITY_ENFORCED 
                     LIMIT 1]
                ),
                ACME_Demographic_Points__c = calculateDemographicScore(
                    [SELECT Id, NumberOfEmployees, Industry 
                     FROM Lead 
                     WHERE Id = :leadId 
                     WITH SECURITY_ENFORCED 
                     LIMIT 1]
                )
            );
            
            // Perform update with security check
            if (Schema.sObjectType.Lead.isUpdateable()) {
                update leadToUpdate;
            }
        } catch (Exception e) {
            ACME_LeadScoreLogger.logError('Lead Score Update Error', e);
        }
    }
}