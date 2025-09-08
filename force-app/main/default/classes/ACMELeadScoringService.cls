public with sharing class ACMELeadScoringService {
    public static List<Decimal> getLeadScores(List<Lead> leads) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = 
            [SELECT MasterLabel, Weight__c 
             FROM ACME_Scoring_Configuration__mdt];
        
        List<Decimal> scores = new List<Decimal>();
        
        for (Lead lead : leads) {
            Decimal score = 0;
            for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
                score += calculateScoreForConfig(lead, config);
            }
            scores.add(score);
        }
        
        return scores;
    }
    
    private static Decimal calculateScoreForConfig(Lead lead, ACME_Scoring_Configuration__mdt config) {
        // Implement scoring logic using config.Weight__c
        Decimal score = 0;
        // Example scoring logic
        if (config.MasterLabel == 'Industry') {
            score = config.Weight__c * getIndustryScore(lead);
        }
        // Add more scoring criteria
        
        return score;
    }
    
    private static Decimal getIndustryScore(Lead lead) {
        // Implement industry-specific scoring logic
        return 1.0; // Placeholder
    }
}