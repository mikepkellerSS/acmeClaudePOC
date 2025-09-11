/**
 * @description Lead Scoring Service for automated lead qualification
 * @author Acme Corp Development Team
 * @date 2024-02-15
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

        for (Lead lead : leads) {
            Integer demographicScore = calculateDemographicScore(lead);
            Integer engagementScore = calculateEngagementScore(lead);
            
            lead.Demographic_Score__c = demographicScore;
            lead.Engagement_Score__c = engagementScore;
            lead.Lead_Score__c = demographicScore + engagementScore;
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

    /**
     * Create lead scoring history record for audit trail
     * @param leadId Lead record ID
     * @param previousScore Previous lead score
     * @param newScore New lead score
     */
    public static void createLeadScoringHistory(Id leadId, Decimal previousScore, Decimal newScore) {
        LeadScoringHistory__c history = new LeadScoringHistory__c(
            Lead__c = leadId,
            Previous_Score__c = previousScore,
            New_Score__c = newScore,
            Timestamp__c = System.now()
        );
        
        try {
            insert history;
        } catch (Exception e) {
            System.debug('Error creating lead scoring history: ' + e.getMessage());
        }
    }
}