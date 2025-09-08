public with sharing class ACMELeadScoringService {
    public static List<ACME_Scoring_Configuration__mdt> getScoringConfigurations() {
        return [SELECT MasterLabel, Weight__c 
                FROM ACME_Scoring_Configuration__mdt];
    }

    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> configurations = getScoringConfigurations();
        Decimal totalScore = 0;

        for (ACME_Scoring_Configuration__mdt config : configurations) {
            totalScore += calculateConfigScore(leadRecord, config);
        }

        return totalScore;
    }

    private static Decimal calculateConfigScore(Lead leadRecord, ACME_Scoring_Configuration__mdt config) {
        Decimal score = 0;
        String fieldName = config.MasterLabel;
        Decimal weight = config.Weight__c != null ? config.Weight__c : 0;

        Object fieldValue = leadRecord.get(fieldName);
        
        if (fieldValue != null) {
            if (fieldValue instanceof Boolean) {
                score = (Boolean)fieldValue ? weight : 0;
            } else if (fieldValue instanceof String) {
                score = String.isNotBlank((String)fieldValue) ? weight : 0;
            } else if (fieldValue instanceof Decimal || fieldValue instanceof Integer) {
                score = ((Decimal)fieldValue > 0) ? weight : 0;
            }
        }

        return score;
    }
}