public with sharing class ACME_LeadScoringService {
    // Core lead scoring calculation logic
    public static void calculateLeadScore(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer score = calculateScore(lead);
            lead.ACME_Lead_Score__c = score;
            lead.ACME_Lead_Score_Last_Updated__c = System.now();
            lead.ACME_Lead_Engagement_Level__c = determineEngagementLevel(score);
        }
    }

    private static Integer calculateScore(Lead lead) {
        Integer score = 0;
        
        // Demographic Factors (20%)
        score += calculateDemographicScore(lead);
        
        // Engagement Metrics (50%)
        score += calculateEngagementScore(lead);
        
        // Company Size/Revenue (30%)
        score += calculateCompanyScore(lead);
        
        // Ensure score is between 0-100
        return Math.min(Math.max(score, 0), 100);
    }

    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;
        
        // Example demographic scoring logic
        if (String.isNotBlank(lead.Title)) {
            demographicScore += 10;
        }
        
        if (String.isNotBlank(lead.Email)) {
            demographicScore += 15;
        }
        
        return demographicScore;
    }

    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;
        
        // Example engagement scoring logic
        // Assumes tracking of engagement fields
        if (lead.NumberOfEmployees > 0) {
            engagementScore += 20;
        }
        
        // Add more engagement metrics
        
        return engagementScore;
    }

    private static Integer calculateCompanyScore(Lead lead) {
        Integer companyScore = 0;
        
        // Example company scoring logic
        if (lead.AnnualRevenue != null && lead.AnnualRevenue > 1000000) {
            companyScore += 30;
        }
        
        return companyScore;
    }

    private static String determineEngagementLevel(Integer score) {
        if (score < 20) return 'Low';
        if (score < 50) return 'Medium';
        if (score < 80) return 'High';
        return 'Very High';
    }
}