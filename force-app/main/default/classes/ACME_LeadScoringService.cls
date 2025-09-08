/**
 * @description Lead scoring service for calculating and updating lead scores
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographic criteria
     * @param leadId ID of lead to score
     * @return Calculated lead score
     */
    public static Integer calculateLeadScore(Id leadId) {
        // Validate input
        if (leadId == null) {
            throw new ACME_LeadScoringException('Lead ID cannot be null');
        }

        try {
            // Retrieve lead with necessary fields
            Lead leadRecord = [
                SELECT Id, Email, Company, NumberOfEmployees, 
                       Industry, Title, Country
                FROM Lead 
                WHERE Id = :leadId 
                WITH SECURITY_ENFORCED
                LIMIT 1
            ];

            // Calculate engagement score (0-50 points)
            Integer engagementScore = calculateEngagementScore(leadRecord);

            // Calculate demographic score (0-50 points)
            Integer demographicScore = calculateDemographicScore(leadRecord);

            // Total score
            Integer totalScore = Math.min(Math.max(engagementScore + demographicScore, 0), 100);

            // Update lead with new score
            updateLeadScore(leadId, totalScore);

            return totalScore;
        } catch (Exception e) {
            // Log and rethrow with custom exception
            System.debug(LoggingLevel.ERROR, 'Lead scoring error: ' + e.getMessage());
            throw new ACME_LeadScoringException('Score calculation failed: ' + e.getMessage());
        }
    }

    /**
     * Calculate engagement score based on lead interactions
     * @param lead Lead record to score
     * @return Engagement score (0-50)
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;

        // Email opens (hypothetical tracking)
        if (String.isNotBlank(lead.Email)) {
            engagementScore += 10;
        }

        // Additional engagement scoring logic would be implemented here
        // Examples: website visits, content downloads, etc.

        return Math.min(engagementScore, 50);
    }

    /**
     * Calculate demographic score based on lead attributes
     * @param lead Lead record to score
     * @return Demographic score (0-50)
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;

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
                demographicScore += 15;
            }
        }

        // Job title scoring
        if (String.isNotBlank(lead.Title)) {
            List<String> seniorTitles = new List<String>{'Director', 'VP', 'C-Level', 'President'};
            for (String title : seniorTitles) {
                if (lead.Title.containsIgnoreCase(title)) {
                    demographicScore += 15;
                    break;
                }
            }
        }

        return Math.min(demographicScore, 50);
    }

    /**
     * Update lead record with calculated score
     * @param leadId Lead record ID
     * @param score Calculated lead score
     */
    private static void updateLeadScore(Id leadId, Integer score) {
        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Scored_Date__c = System.now()
        );

        // Perform update with system context to bypass sharing rules
        Database.update(leadToUpdate, false);
    }

    /**
     * Custom exception for lead scoring errors
     */
    public class ACME_LeadScoringException extends Exception {}
}