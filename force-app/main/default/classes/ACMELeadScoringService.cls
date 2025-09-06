/**
 * @description Service class for lead scoring calculations
 * @author ACME Development Team
 * @date 2024-02-15
 */
public with sharing class ACMELeadScoringService {
    
    // Scoring weights (configurable)
    private static final Decimal ENGAGEMENT_WEIGHT = 0.6;
    private static final Decimal DEMOGRAPHIC_WEIGHT = 0.4;
    
    /**
     * Calculate lead score based on engagement and demographic factors
     * @param lead Lead record to score
     * @return Calculated lead score
     */
    public static Decimal calculateLeadScore(Lead lead) {
        try {
            Decimal engagementScore = calculateEngagementScore(lead);
            Decimal demographicScore = calculateDemographicScore(lead);
            
            Decimal totalScore = (engagementScore * ENGAGEMENT_WEIGHT) + 
                                  (demographicScore * DEMOGRAPHIC_WEIGHT);
            
            // Ensure score is between 0 and 100
            return Math.min(Math.max(totalScore, 0), 100).setScale(0);
        } catch (Exception e) {
            // Log error and return default score
            System.debug(LoggingLevel.ERROR, 'Lead Scoring Error: ' + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Calculate engagement score based on interaction metrics
     * @param lead Lead record
     * @return Engagement score
     */
    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal score = 0;
        
        // Email opens (hypothetical fields)
        if (lead.Email_Opens__c != null) {
            score += Math.min(lead.Email_Opens__c * 5, 20);
        }
        
        // Website visits
        if (lead.Website_Visits__c != null) {
            score += Math.min(lead.Website_Visits__c * 3, 15);
        }
        
        // Content downloads
        if (lead.Content_Downloads__c != null) {
            score += Math.min(lead.Content_Downloads__c * 4, 20);
        }
        
        return Math.min(score, 50);
    }
    
    /**
     * Calculate demographic score based on lead attributes
     * @param lead Lead record
     * @return Demographic score
     */
    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal score = 0;
        
        // Company size scoring
        if (lead.Number_of_Employees__c != null) {
            if (lead.Number_of_Employees__c >= 1000) {
                score += 20;
            } else if (lead.Number_of_Employees__c >= 100) {
                score += 10;
            }
        }
        
        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            Set<String> targetIndustries = new Set<String>{
                'Technology', 'Finance', 'Healthcare'
            };
            
            if (targetIndustries.contains(lead.Industry)) {
                score += 15;
            }
        }
        
        // Job title scoring
        if (String.isNotBlank(lead.Title)) {
            Set<String> decisionMakerTitles = new Set<String>{
                'CEO', 'CTO', 'CFO', 'Director', 'VP'
            };
            
            for (String title : decisionMakerTitles) {
                if (lead.Title.containsIgnoreCase(title)) {
                    score += 15;
                    break;
                }
            }
        }
        
        return Math.min(score, 50);
    }
    
    /**
     * Update lead score on the record
     * @param leadId ID of the lead to update
     */
    public static void updateLeadScore(Id leadId) {
        Lead leadToUpdate = [
            SELECT Id, ACME_Lead_Score__c, 
                   Email_Opens__c, Website_Visits__c, 
                   Content_Downloads__c, Industry, 
                   Number_of_Employees__c, Title
            FROM Lead 
            WHERE Id = :leadId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        
        Decimal newScore = calculateLeadScore(leadToUpdate);
        
        // Only update if score has changed
        if (leadToUpdate.ACME_Lead_Score__c != newScore) {
            leadToUpdate.ACME_Lead_Score__c = newScore;
            leadToUpdate.ACME_Last_Scoring_Date__c = System.now();
            
            try {
                update leadToUpdate;
            } catch (DmlException e) {
                System.debug(LoggingLevel.ERROR, 'Error updating lead score: ' + e.getMessage());
            }
        }
    }
}