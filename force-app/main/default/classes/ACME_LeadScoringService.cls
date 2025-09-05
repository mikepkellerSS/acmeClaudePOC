public with sharing class ACME_LeadScoringService {
    // Custom Metadata Type for Scoring Configuration
    private static final List<Lead_Scoring_Criteria__mdt> scoringCriteria = 
        Lead_Scoring_Criteria__mdt.getAll().values();

    public static void calculateLeadScore(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer totalScore = calculateDemographicScore(lead) + 
                                 calculateEngagementScore(lead);
            
            lead.ACME_Lead_Score__c = Math.min(Math.max(totalScore, 0), 100);
            lead.ACME_Last_Score_Calculation__c = System.now();
        }
    }

    private static Integer calculateDemographicScore(Lead lead) {
        Integer demographicScore = 0;
        
        // Example demographic scoring logic
        if (String.isNotBlank(lead.Company)) {
            demographicScore += 10;
        }
        
        if (String.isNotBlank(lead.Title)) {
            demographicScore += 10;
        }
        
        return demographicScore;
    }

    private static Integer calculateEngagementScore(Lead lead) {
        Integer engagementScore = 0;
        
        // Example engagement scoring logic
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 100) {
            engagementScore += 30;
        }
        
        if (lead.Email != null) {
            engagementScore += 50;
        }
        
        return engagementScore;
    }

    @InvocableMethod(label='Calculate Lead Score')
    public static void invocableCalculateLeadScore(List<Lead> leads) {
        calculateLeadScore(leads);
        update leads;
    }
}