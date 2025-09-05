/**
 * Handles lead scoring calculations and logic
 * Implements complex scoring algorithm for lead qualification
 */
public with sharing class ACME_LeadScoreHandler {
    
    /**
     * Calculate lead score based on engagement and demographic factors
     * @param leadId The ID of the lead to score
     * @return Calculated lead score
     */
    public static Decimal calculateLeadScore(Id leadId) {
        // Validate input
        if (leadId == null) {
            return 0;
        }

        // Retrieve lead with necessary fields
        Lead leadRecord = retrieveLead(leadId);
        
        if (leadRecord == null) {
            return 0;
        }

        // Calculate engagement score (50%)
        Decimal engagementScore = calculateEngagementScore(leadRecord);
        
        // Calculate demographic score (50%)
        Decimal demographicScore = calculateDemographicScore(leadRecord);
        
        // Combine scores
        Decimal totalScore = (engagementScore + demographicScore) / 2;
        
        // Update lead with new score
        updateLeadScore(leadId, totalScore);
        
        return totalScore;
    }

    /**
     * Retrieve lead with necessary fields for scoring
     * @param leadId Lead record ID
     * @return Lead record
     */
    private static Lead retrieveLead(Id leadId) {
        // Ensure field accessibility
        if (!Schema.SObjectType.Lead.isAccessible()) {
            return null;
        }

        try {
            return [
                SELECT Id, 
                       Company, 
                       NumberOfEmployees, 
                       Industry, 
                       Title,
                       Email,
                       Website
                FROM Lead 
                WHERE Id = :leadId 
                LIMIT 1
            ];
        } catch (QueryException e) {
            // Log error
            System.debug(LoggingLevel.ERROR, 'Error retrieving lead: ' + e.getMessage());
            return null;
        }
    }

    /**
     * Calculate engagement score based on interactions
     * @param lead Lead record
     * @return Engagement score (0-100)
     */
    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal engagementScore = 0;

        // Website visits (hypothetical tracking)
        if (String.isNotBlank(lead.Website)) {
            engagementScore += 20;
        }

        // Email interactions
        if (String.isNotBlank(lead.Email)) {
            engagementScore += 30;
        }

        // Limit score to 50
        return Math.min(engagementScore, 50);
    }

    /**
     * Calculate demographic score based on company attributes
     * @param lead Lead record
     * @return Demographic score (0-100)
     */
    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal demographicScore = 0;

        // Company size scoring
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees > 1000) {
                demographicScore += 20;
            } else if (lead.NumberOfEmployees > 100) {
                demographicScore += 10;
            }
        }

        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            List<String> targetIndustries = new List<String>{'Technology', 'Finance', 'Healthcare'};
            if (targetIndustries.contains(lead.Industry)) {
                demographicScore += 20;
            }
        }

        // Job title scoring
        if (String.isNotBlank(lead.Title)) {
            List<String> seniorTitles = new List<String>{'CEO', 'CTO', 'Director', 'VP'};
            for (String title : seniorTitles) {
                if (lead.Title.containsIgnoreCase(title)) {
                    demographicScore += 10;
                    break;
                }
            }
        }

        // Limit score to 50
        return Math.min(demographicScore, 50);
    }

    /**
     * Update lead record with calculated score
     * @param leadId Lead record ID
     * @param score Calculated lead score
     */
    private static void updateLeadScore(Id leadId, Decimal score) {
        // Ensure update permissions
        if (!Schema.SObjectType.Lead.isUpdateable()) {
            return;
        }

        try {
            Lead leadToUpdate = new Lead(
                Id = leadId,
                ACME_Lead_Score__c = score,
                ACME_Score_Last_Updated__c = System.now()
            );
            
            Database.update(leadToUpdate, false);
        } catch (Exception e) {
            // Log error
            System.debug(LoggingLevel.ERROR, 'Error updating lead score: ' + e.getMessage());
        }
    }
}