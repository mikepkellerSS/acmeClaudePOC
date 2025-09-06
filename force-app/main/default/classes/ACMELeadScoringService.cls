public with sharing class ACMELeadScoringService {
    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = 
            [SELECT MasterLabel, ACME_Weight__c 
             FROM ACME_Scoring_Configuration__mdt];
        
        Decimal totalScore = 0;
        
        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            totalScore += calculateConfigScore(leadRecord, config);
        }
        
        return totalScore;
    }
    
    private static Decimal calculateConfigScore(Lead lead, ACME_Scoring_Configuration__mdt config) {
        Decimal score = 0;
        
        switch on config.MasterLabel {
            when 'Industry' {
                score = config.ACME_Weight__c * getIndustryScore(lead);
            }
            when 'Company Size' {
                score = config.ACME_Weight__c * getCompanySizeScore(lead);
            }
            when 'Lead Source' {
                score = config.ACME_Weight__c * getLeadSourceScore(lead);
            }
        }
        
        return score;
    }
    
    private static Decimal getIndustryScore(Lead lead) {
        Map<String, Decimal> industryScores = new Map<String, Decimal>{
            'Technology' => 1.0,
            'Finance' => 0.8,
            'Healthcare' => 0.9,
            'Retail' => 0.7
        };
        
        return industryScores.containsKey(lead.Industry) 
            ? industryScores.get(lead.Industry) 
            : 0.5;
    }
    
    private static Decimal getCompanySizeScore(Lead lead) {
        // Implement company size scoring logic
        return 0.6; // Placeholder
    }
    
    private static Decimal getLeadSourceScore(Lead lead) {
        // Implement lead source scoring logic
        return 0.7; // Placeholder
    }
}