/**
 * @description Lead Scoring Service for automated lead qualification
 * @author Acme Corp
 * @date 2024
 */
public with sharing class ACME_LeadScoringService {
    private static final Integer MAX_DEMOGRAPHIC_SCORE = 40;
    private static final Integer MAX_ENGAGEMENT_SCORE = 60;
    private static final Set<String> SENIOR_TITLES = new Set<String>{
        'Manager', 'Director', 'VP', 'C-Level', 'Chief', 'President'
    };
    private static final Set<String> TARGET_INDUSTRIES = new Set<String>{
        'Technology', 'Healthcare', 'Finance'
    };

    /**
     * Calculate lead score for a collection of leads
     * @param leads List of leads to score
     * @return List of leads with updated scores
     */
    public static List<Lead> calculateLeadScores(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer demographicScore = calculateDemographicScore(lead);
            Integer engagementScore = calculateEngagementScore(lead);
            
            lead.ACME__Demographic_Score__c = demographicScore;
            lead.ACME__Engagement_Score__c = engagementScore;
            lead.ACME__Lead_Score__c = demographicScore + engagementScore;

            // Create scoring history record
            createScoringHistoryRecord(lead);
        }
        return leads;
    }

    /**
     * Calculate demographic score based on job title, company size, and industry
     * @param lead Lead record to evaluate
     * @return Demographic score
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

        return Math.min(score, MAX_DEMOGRAPHIC_SCORE);
    }

    /**
     * Calculate engagement score based on lead interactions
     * @param lead Lead record to evaluate
     * @return Engagement score
     */
    private static Integer calculateEngagementScore(Lead lead) {
        Integer score = 0;

        // Whitepaper Download
        if (lead.ACME__Whitepaper_Downloaded__c == true) {
            score += 10;
        }

        // Webinar Attendance
        if (lead.ACME__Webinar_Attended__c == true) {
            score += 15;
        }

        // Pricing Page Visit
        if (lead.ACME__Pricing_Page_Visited__c == true) {
            score += 20;
        }

        // Demo Request
        if (lead.ACME__Demo_Requested__c == true) {
            score += 15;
        }

        return Math.min(score, MAX_ENGAGEMENT_SCORE);
    }

    /**
     * Create lead scoring history record
     * @param lead Lead record with updated score
     */
    private static void createScoringHistoryRecord(Lead lead) {
        ACME_LeadScoringHistory__c history = new ACME_LeadScoringHistory__c(
            ACME__Lead__c = lead.Id,
            ACME__Previous_Score__c = lead.ACME__Lead_Score__c ?? 0,
            ACME__New_Score__c = lead.ACME__Lead_Score__c,
            ACME__Timestamp__c = System.now()
        );
        
        try {
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_LeadScoringService', 'createScoringHistoryRecord', e);
        }
    }
}