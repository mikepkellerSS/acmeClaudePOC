public with sharing class ACMELeadScoringService {
    private ACME_Scoring_Configuration__mdt config;

    public ACMELeadScoringService() {
        List<ACME_Scoring_Configuration__mdt> configs = 
            [SELECT Threshold__c, Weight__c 
             FROM ACME_Scoring_Configuration__mdt 
             WHERE DeveloperName = 'Default' 
             LIMIT 1];
        
        if (!configs.isEmpty()) {
            config = configs[0];
        } else {
            // Provide default values if no configuration is found
            config = new ACME_Scoring_Configuration__mdt(
                Threshold__c = 50,
                Weight__c = 0.5
            );
        }
    }

    public Integer calculateLeadScore(Lead leadRecord) {
        if (config == null) {
            throw new System.NoDataFoundException('No scoring configuration found');
        }

        Integer score = 0;
        Double weight = config.Weight__c != null ? config.Weight__c : 0.5;
        
        // Example scoring logic with null checks
        if (leadRecord.NumberOfEmployees != null) {
            score += Math.round(leadRecord.NumberOfEmployees * weight);
        }

        if (leadRecord.AnnualRevenue != null) {
            score += Math.round(leadRecord.AnnualRevenue / 1000 * weight);
        }

        return score;
    }

    public Boolean isQualifiedLead(Integer score) {
        Double threshold = config.Threshold__c != null ? config.Threshold__c : 50;
        return score >= threshold;
    }
}