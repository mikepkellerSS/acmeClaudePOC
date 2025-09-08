public with sharing class ACMELeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = [
            SELECT Field_Name__c, Score_Value__c 
            FROM ACME_Scoring_Configuration__mdt
        ];

        for (Lead lead : leads) {
            Integer totalScore = 0;
            
            for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
                Object fieldValue = lead.get(config.Field_Name__c);
                if (fieldValue != null) {
                    totalScore += Integer.valueOf(config.Score_Value__c);
                }
            }

            lead.Lead_Score__c = totalScore;
        }
    }
}