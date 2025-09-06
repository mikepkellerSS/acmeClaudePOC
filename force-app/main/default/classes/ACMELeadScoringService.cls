public with sharing class ACMELeadScoringService {
    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = 
            [SELECT MasterLabel, ACME_Weight__c 
             FROM ACME_Scoring_Configuration__mdt];
        
        Decimal totalScore = 0;
        
        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            // Implement scoring logic using ACME_Weight__c
            if (config.MasterLabel == 'Industry') {
                totalScore += calculateIndustryScore(leadRecord) * config.ACME_Weight__c;
            }
            // Add more scoring criteria as needed
        }
        
        return totalScore;
    }
    
    private static Decimal calculateIndustryScore(Lead lead) {
        // Example industry scoring logic
        if (lead.Industry == 'Technology') return 10;
        if (lead.Industry == 'Finance') return 8;
        return 5;
    }
}