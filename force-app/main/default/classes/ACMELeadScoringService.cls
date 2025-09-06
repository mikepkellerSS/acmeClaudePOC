public with sharing class ACMELeadScoringService {
    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = 
            [SELECT MasterLabel, ACME_Weight__c, IsActive__c 
             FROM ACME_Scoring_Configuration__mdt 
             WHERE IsActive__c = true];
        
        Decimal totalScore = 0;
        
        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            Decimal weight = config.ACME_Weight__c != null ? config.ACME_Weight__c : 0;
            
            // Add scoring logic based on configuration
            if (config.MasterLabel == 'Revenue Potential') {
                totalScore += calculateRevenueScore(leadRecord) * weight;
            }
            // Add more scoring criteria as needed
        }
        
        return totalScore;
    }
    
    private static Decimal calculateRevenueScore(Lead lead) {
        // Implement revenue scoring logic
        // Placeholder implementation
        return lead.AnnualRevenue != null ? lead.AnnualRevenue / 1000 : 0;
    }
}