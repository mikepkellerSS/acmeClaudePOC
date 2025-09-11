/**
 * Lead Scoring Service for Acme Corp
 * Calculates lead scores based on demographic and engagement criteria
 * @author Acme Corp Development Team
 * @date 2024
 */
public with sharing class ACME_LeadScoringService {
    private static final Set<String> TARGET_INDUSTRIES = new Set<String>{
        'Technology', 'Healthcare', 'Finance'
    };
    
    private static final Set<String> SENIOR_TITLES = new Set<String>{
        'Manager', 'Director', 'VP', 'C-Level'
    };

    /**
     * Calculate lead scores for a list of leads
     * @param leads List of leads to score
     * @return List of leads with updated scores
     */
    public static List<Lead> calculateLeadScores(List<Lead> leads) {
        for (Lead lead : leads) {
            try {
                Integer demographicScore = calculateDemographicScore(lead);
                Integer engagementScore = calculateEngagementScore(lead);
                
                lead.ACME__Demographic_Score__c = demographicScore;
                lead.ACME__Engagement_Score__c = engagementScore;
                lead.ACME__Lead_Score__c = demographicScore + engagementScore;
                
                // Ensure score is between 0-100
                lead.ACME__Lead_Score__c = Math.min(100, Math.max(0, lead.ACME__Lead_Score__c));
            } catch (Exception e) {
                ACME_ErrorHandler.logError('ACME_LeadScoringService', 'calculateLeadScores', e);
            }
        }
        return leads;
    }

    /**
     * Calculate demographic score for a lead
     * @param lead Lead to evaluate
     * @return Demographic score (0-40)
     */
    private static Integer calculateDemographicScore(Lead lead) {
        Integer score = 0;

        // Job Title Score (15 points)
        if (String.isNotBlank(lead.Title)) {
            for (String title : SENIOR_TITLES) {
                if (lead.Title.containsIgnoreCase(title)) {
                    score += 15;
                    break;
                }
            }
        }

        // Company Size Score (10 points)
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 500) {
            score += 10;
        }

        // Industry Score (15 points)
        if (String.isNotBlank(lead.Industry) && TARGET_INDUSTRIES.contains(lead.Industry)) {
            score += 15;
        }

        return score;
    }

    /**
     * Calculate engagement score for a lead
     * @param lead Lead to evaluate
     * @return Engagement score (0-60)
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer score = 0;

        // Whitepaper Download (10 points)
        if (lead.ACME__Whitepaper_Downloaded__c == true) {
            score += 10;
        }

        // Webinar Attendance (15 points)
        if (lead.ACME__Webinar_Attended__c == true) {
            score += 15;
        }

        // Pricing Page Visit (20 points)
        if (lead.ACME__Pricing_Page_Visited__c == true) {
            score += 20;
        }

        // Demo Request (15 points)
        if (lead.ACME__Demo_Requested__c == true) {
            score += 15;
        }

        return score;
    }

    /**
     * Create lead scoring history record
     * @param oldLead Previous lead state
     * @param newLead Current lead state
     */
    public static void createLeadScoringHistory(Lead oldLead, Lead newLead) {
        if (oldLead == null || newLead.ACME__Lead_Score__c != oldLead.ACME__Lead_Score__c) {
            ACME__Lead_Scoring_History__c history = new ACME__Lead_Scoring_History__c(
                ACME__Lead__c = newLead.Id,
                ACME__Previous_Score__c = oldLead?.ACME__Lead_Score__c,
                ACME__New_Score__c = newLead.ACME__Lead_Score__c,
                ACME__Timestamp__c = System.now()
            );
            insert history;
        }
    }
}