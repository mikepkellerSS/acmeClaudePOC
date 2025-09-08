public with sharing class ACMELeadScoringService {
    public static List<ACME_Scoring_Configuration__mdt> getScoringConfigurations() {
        return [
            SELECT MasterLabel, ACME_Weight__c 
            FROM ACME_Scoring_Configuration__mdt
        ];
    }

    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = getScoringConfigurations();
        Decimal totalScore = 0;

        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            if (config.MasterLabel == 'Company Size') {
                totalScore += calculateCompanySizeScore(leadRecord, config.ACME_Weight__c);
            } else if (config.MasterLabel == 'Industry') {
                totalScore += calculateIndustryScore(leadRecord, config.ACME_Weight__c);
            } else if (config.MasterLabel == 'Job Title') {
                totalScore += calculateJobTitleScore(leadRecord, config.ACME_Weight__c);
            }
        }

        return totalScore;
    }

    private static Decimal calculateCompanySizeScore(Lead leadRecord, Decimal weight) {
        // Implement company size scoring logic
        return 0;
    }

    private static Decimal calculateIndustryScore(Lead leadRecord, Decimal weight) {
        // Implement industry scoring logic
        return 0;
    }

    private static Decimal calculateJobTitleScore(Lead leadRecord, Decimal weight) {
        // Implement job title scoring logic
        return 0;
    }
}