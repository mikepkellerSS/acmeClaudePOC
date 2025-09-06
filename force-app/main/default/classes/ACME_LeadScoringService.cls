/**
 * Lead Scoring Service for calculating and managing lead scores
 * Implements complex scoring logic with security and performance considerations
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate total lead score based on engagement and demographic factors
     * @param lead The lead record to score
     * @return Integer representing the total lead score (0-100)
     */
    public static Integer calculateLeadScore(Lead lead) {
        if (lead == null) {
            return 0;
        }

        Integer engagementScore = calculateEngagementScore(lead);
        Integer demographicScore = calculateDemographicScore(lead);
        
        return Math.min(engagementScore + demographicScore, 100);
    }

    /**
     * Calculate engagement score based on interaction metrics
     * @param lead The lead record to evaluate
     * @return Integer representing engagement score (0-50)
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer score = 0;

        // Email opens scoring
        if (lead.Email_Opens__c != null) {
            score += Math.min(lead.Email_Opens__c.intValue() * 5, 20);
        }

        // Website visits scoring
        if (lead.Website_Visits__c != null) {
            score += Math.min(lead.Website_Visits__c.intValue() * 3, 15);
        }

        // Content downloads scoring
        if (lead.Content_Downloads__c != null) {
            score += Math.min(lead.Content_Downloads__c.intValue() * 5, 15);
        }

        return Math.min(score, 50);
    }

    /**
     * Calculate demographic score based on ideal customer profile
     * @param lead The lead record to evaluate
     * @return Integer representing demographic score (0-50)
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer score = 0;

        // Company size scoring
        if (lead.Number_of_Employees__c != null) {
            if (lead.Number_of_Employees__c >= 500) {
                score += 20;
            } else if (lead.Number_of_Employees__c >= 100) {
                score += 10;
            }
        }

        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            List<String> targetIndustries = new List<String>{'Technology', 'Finance', 'Healthcare'};
            if (targetIndustries.contains(lead.Industry)) {
                score += 15;
            }
        }

        // Job title scoring
        if (String.isNotBlank(lead.Title)) {
            List<String> decisionMakerTitles = new List<String>{'CEO', 'CTO', 'Director', 'VP'};
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
     * Update lead score and timestamp
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leads) {
            if (Schema.sObjectType.Lead.isUpdateable()) {
                Integer totalScore = calculateLeadScore(lead);
                
                lead.ACME_Lead_Score__c = totalScore;
                lead.ACME_Score_Last_Updated__c = System.now();
                
                leadsToUpdate.add(lead);
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            try {
                update leadsToUpdate;
            } catch (DmlException e) {
                // Log error or handle appropriately
                System.debug('Error updating lead scores: ' + e.getMessage());
            }
        }
    }
}