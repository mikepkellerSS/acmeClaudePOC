public with sharing class ACMELeadScoringService {
    public static List<ACME_Scoring_Configuration__mdt> getScoringConfigurations() {
        return [
            SELECT MasterLabel, Weight__c 
            FROM ACME_Scoring_Configuration__mdt
        ];
    }

    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> configs = getScoringConfigurations();
        Decimal totalScore = 0;

        for (ACME_Scoring_Configuration__mdt config : configs) {
            // Implement scoring logic using Weight__c instead of ACME_Weight__c
            totalScore += calculateConfigScore(leadRecord, config);
        }

        return totalScore;
    }

    private static Decimal calculateConfigScore(Lead leadRecord, ACME_Scoring_Configuration__mdt config) {
        // Implement specific scoring calculation
        return 0; // Placeholder
    }
}