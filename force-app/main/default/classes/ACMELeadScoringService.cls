public with sharing class ACMELeadScoringService {
    public static List<Lead> scoreLead(List<Lead> leads) {
        List<ACME_Scoring_Configuration__mdt> config = 
            [SELECT DeveloperName, Score_Value__c, Field_Name__c 
             FROM ACME_Scoring_Configuration__mdt];
        
        for (Lead lead : leads) {
            Integer totalScore = 0;
            
            for (ACME_Scoring_Configuration__mdt scoring : config) {
                Object fieldValue = lead.get(scoring.Field_Name__c);
                if (fieldValue != null) {
                    totalScore += Integer.valueOf(scoring.Score_Value__c);
                }
            }
            
            lead.Lead_Score__c = totalScore;
        }
        
        return leads;
    }
}