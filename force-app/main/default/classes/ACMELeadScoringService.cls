public with sharing class ACMELeadScoringService {
    public static Decimal calculateLeadScore(Lead leadRecord) {
        Decimal totalScore = 0;
        
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = [
            SELECT MasterLabel, ACME_Weight__c, ACME_Field__c, ACME_Condition__c, ACME_Score__c 
            FROM ACME_Scoring_Configuration__mdt
        ];
        
        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            Object fieldValue = leadRecord.get(config.ACME_Field__c);
            
            if (meetsCondition(fieldValue, config.ACME_Condition__c)) {
                totalScore += (config.ACME_Score__c * config.ACME_Weight__c);
            }
        }
        
        return totalScore;
    }
    
    private static Boolean meetsCondition(Object fieldValue, String condition) {
        // Implement condition matching logic
        return true;
    }
}