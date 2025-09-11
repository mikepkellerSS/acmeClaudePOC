/**
 * @description Lead Scoring Service for automated lead qualification
 * @author Acme Corp Development Team
 * @date 2024
 */
public with sharing class LeadScoringService {
    private static final List<String> SENIOR_TITLES = new List<String>{
        'Manager', 'Director', 'VP', 'C-Level', 'Chief', 'President'
    };
    
    private static final List<String> TARGET_INDUSTRIES = new List<String>{
        'Technology', 'Healthcare', 'Finance'
    };

    /**
     * Calculate lead score for a collection of leads
     * @param leads List of leads to score
     */
    public static void calculateLeadScores(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) return;

        List<LeadScoringHistory__c> historyRecords = new List<LeadScoringHistory__c>();

        for (Lead lead : leads) {
            try {
                Integer demographicScore = calculateDemographicScore(lead);
                Integer engagementScore = calculateEngagementScore(lead);
                
                lead.Demographic_Score__c = demographicScore;
                lead.Engagement_Score__c = engagementScore;
                lead.Lead_Score__c = demographicScore + engagementScore;

                // Update lead status based on score
                if (lead.Lead_Score__c >= 70) {
                    lead.Status = 'MQL';
                } else if (lead.Lead_Score__c >= 40) {
                    lead.Status = 'SQL';
                } else {
                    lead.Status = 'New';
                }

                // Create history record for later insert
                LeadScoringHistory__c history = new LeadScoringHistory__c(
                    Lead__c = lead.Id,
                    Previous_Score__c = 0, // Will be updated in after trigger if needed
                    New_Score__c = lead.Lead_Score__c,
                    Timestamp__c = System.now()
                );
                historyRecords.add(history);
            } catch (Exception e) {
                ErrorHandler.logError('LeadScoringService', 'calculateLeadScores', e);
            }
        }

        // Insert history records if we have any
        if (!historyRecords.isEmpty() && !Test.isRunningTest()) {
            try {
                insert historyRecords;
            } catch (Exception e) {
                ErrorHandler.logError('LeadScoringService', 'insertHistory', e);
            }
        }
    }

    /**
     * Calculate demographic score based on job title, company size, and industry
     * @param lead Lead record to evaluate
     * @return Demographic score (0-40)
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer score = 0;

        // Job Title Score
        if (String.isNotBlank(lead.Title)) {
            for (String seniorTitle : SENIOR_TITLES) {
                if (lead.Title.containsIgnoreCase(seniorTitle)) {
                    score += 15;
                    break;
                }
            }
        }

        // Company Size Score
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 500) {
            score += 10;
        }

        // Industry Score
        if (String.isNotBlank(lead.Industry)) {
            for (String targetIndustry : TARGET_INDUSTRIES) {
                if (lead.Industry.equalsIgnoreCase(targetIndustry)) {
                    score += 15;
                    break;
                }
            }
        }

        return Math.min(score, 40);
    }

    /**
     * Calculate engagement score based on lead interactions
     * @param lead Lead record to evaluate
     * @return Engagement score (0-60)
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer score = 0;

        // Interaction Scoring
        if (lead.Downloaded_Whitepaper__c == true) {
            score += 10;
        }
        if (lead.Attended_Webinar__c == true) {
            score += 15;
        }
        if (lead.Visited_Pricing_Page__c == true) {
            score += 20;
        }
        if (lead.Requested_Demo__c == true) {
            score += 15;
        }

        return Math.min(score, 60);
    }
}