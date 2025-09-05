public with sharing class ACME_LeadScoringService {
    // Core lead scoring calculation logic
    public static void calculateLeadScore(List<Lead> leads) {
        for (Lead lead : leads) {
            // Calculate engagement score
            Decimal engagementScore = calculateEngagementScore(lead);
            lead.ACME_Engagement_Score__c = engagementScore;

            // Calculate demographic score
            Decimal demographicScore = calculateDemographicScore(lead);
            lead.ACME_Demographic_Score__c = demographicScore;

            // Aggregate total lead score
            lead.ACME_Lead_Score__c = calculateTotalScore(engagementScore, demographicScore);
        }
    }

    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal score = 0;
        
        // Sample engagement scoring logic
        if (lead.NumberOfEmployees != null) {
            score += lead.NumberOfEmployees > 100 ? 30 : 10;
        }
        
        if (lead.Email != null) {
            score += 20;
        }
        
        // Add more engagement scoring criteria
        return Math.min(score, 100);
    }

    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal score = 0;
        
        // Sample demographic scoring logic
        if (lead.Industry != null) {
            score += 25;
        }
        
        if (lead.Company != null) {
            score += 25;
        }
        
        // Add more demographic scoring criteria
        return Math.min(score, 100);
    }

    private static Decimal calculateTotalScore(Decimal engagementScore, Decimal demographicScore) {
        // Weighted calculation of total score
        return Math.min((engagementScore * 0.6) + (demographicScore * 0.4), 100);
    }

    // Invocable method for Flow
    @InvocableMethod(label='Calculate Lead Score')
    public static void calculateLeadScoreInvocable(List<Id> leadIds) {
        List<Lead> leads = [SELECT Id, NumberOfEmployees, Email, Industry, Company 
                            FROM Lead 
                            WHERE Id IN :leadIds];
        
        calculateLeadScore(leads);
        
        update leads;
    }
}