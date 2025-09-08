public with sharing class ACMELeadScoringService {
    public static Integer calculateLeadScore(Lead leadRecord) {
        Integer totalScore = 0;
        
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = [
            SELECT MasterLabel, ACME_Weight__c 
            FROM ACME_Scoring_Configuration__mdt
        ];
        
        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            if (config.MasterLabel == 'Industry' && leadRecord.Industry != null) {
                totalScore += Integer.valueOf(config.ACME_Weight__c);
            }
            
            if (config.MasterLabel == 'Company Size' && leadRecord.NumberOfEmployees != null) {
                totalScore += Integer.valueOf(config.ACME_Weight__c);
            }
            
            if (config.MasterLabel == 'Annual Revenue' && leadRecord.AnnualRevenue != null) {
                totalScore += Integer.valueOf(config.ACME_Weight__c);
            }
        }
        
        return totalScore;
    }
}