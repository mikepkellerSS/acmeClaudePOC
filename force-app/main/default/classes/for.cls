/**
 * Service class for lead scoring calculations
 * Implements complex scoring logic across multiple dimensions
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on multiple factors
     * @param lead The lead record to score
     * @return Calculated lead score between 0-100
     */
    public static Decimal calculateLeadScore(Lead lead) {
        Decimal score = 0;
        
        // Demographic scoring
        score += calculateDemographicScore(lead);
        
        // Engagement scoring
        score += calculateEngagementScore(lead);
        
        // Ensure score is within 0-100 range
        return Math.min(Math.max(score, 0), 100);
    }
    
    /**
     * Calculate score based on demographic factors
     * @param lead Lead record to assess
     * @return Demographic score component
     */
    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal demographicScore = 0;
        
        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            switch on lead.Industry.toLowerCase() {
                when 'technology', 'finance' {
                    demographicScore += 30;
                }
                when 'healthcare', 'education' {
                    demographicScore += 20;
                }
                when else {
                    demographicScore += 10;
                }
            }
        }
        
        // Company size scoring
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees > 1000) {
                demographicScore += 25;
            } else if (lead.NumberOfEmployees > 100) {
                demographicScore += 15;
            }
        }
        
        return demographicScore;
    }
    
    /**
     * Calculate score based on engagement metrics
     * @param lead Lead record to assess
     * @return Engagement score component
     */
    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal engagementScore = 0;
        
        // Website interactions (hypothetical tracking)
        if (lead.Website_Visits__c != null) {
            engagementScore += Math.min(lead.Website_Visits__c * 2, 20);
        }
        
        // Email interactions (hypothetical tracking)
        if (lead.Email_Opens__c != null) {
            engagementScore += Math.min(lead.Email_Opens__c * 1.5, 15);
        }
        
        return engagementScore;
    }
    
    /**
     * Update lead score and last scored date
     * @param leadId ID of lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Decimal score) {
        // Verify user has edit permissions
        if (!Schema.sObjectType.Lead.isUpdateable()) {
            throw new System.NoAccessException('Insufficient permissions to update lead');
        }
        
        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Scored_Date__c = System.now()
        );
        
        try {
            update leadToUpdate;
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, 'Lead score update failed: ' + e.getMessage());
            throw e;
        }
    }
}