public with sharing class ACME_LeadScoringService {
    
    public static void calculateLeadScore(List<Lead> leads) {
        for (Lead lead : leads) {
            try {
                // Fetch scoring criteria from custom metadata
                List<ACME_Scoring_Criteria__mdt> scoringRules = 
                    [SELECT DeveloperName, Weight__c, ScoringType__c 
                     FROM ACME_Scoring_Criteria__mdt 
                     WITH SECURITY_ENFORCED];
                
                Decimal engagementScore = calculateEngagementScore(lead, scoringRules);
                Decimal demographicScore = calculateDemographicScore(lead, scoringRules);
                
                lead.ACME_Engagement_Score__c = engagementScore;
                lead.ACME_Demographic_Score__c = demographicScore;
                lead.ACME_Lead_Score__c = calculateFinalScore(engagementScore, demographicScore);
                lead.ACME_Last_Score_Calculation__c = System.now();
            } catch (Exception e) {
                // Log error, don't block processing
                System.debug('Lead Score Calculation Error: ' + e.getMessage());
            }
        }
    }
    
    private static Decimal calculateEngagementScore(Lead lead, List<ACME_Scoring_Criteria__mdt> rules) {
        Decimal score = 0;
        for (ACME_Scoring_Criteria__mdt rule : rules) {
            if (rule.ScoringType__c == 'Engagement') {
                // Implement engagement scoring logic
                // Example placeholder logic
                if (lead.NumberOfFormSubmissions__c > 0) {
                    score += rule.Weight__c * lead.NumberOfFormSubmissions__c;
                }
            }
        }
        return score;
    }
    
    private static Decimal calculateDemographicScore(Lead lead, List<ACME_Scoring_Criteria__mdt> rules) {
        Decimal score = 0;
        for (ACME_Scoring_Criteria__mdt rule : rules) {
            if (rule.ScoringType__c == 'Demographic') {
                // Implement demographic scoring logic
                if (lead.Company_Size__c == 'Enterprise') {
                    score += rule.Weight__c * 10;
                }
            }
        }
        return score;
    }
    
    private static Decimal calculateFinalScore(Decimal engagementScore, Decimal demographicScore) {
        // Normalize and combine scores
        return Math.min(100, engagementScore * 0.6 + demographicScore * 0.4);
    }
}