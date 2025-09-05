public with sharing class ACME_LeadScoreCalculator {
    public Decimal calculateLeadScore(Lead lead) {
        ACME_Scoring_Criteria__mdt scoringCriteria = getScoringCriteria();
        
        Decimal engagementScore = calculateEngagementScore(lead);
        Decimal demographicsScore = calculateDemographicsScore(lead);
        
        lead.ACME_Engagement_Score__c = engagementScore;
        lead.ACME_Demographics_Score__c = demographicsScore;
        
        return (engagementScore * scoringCriteria.Engagement_Weight__c) +
               (demographicsScore * scoringCriteria.Demographics_Weight__c);
    }
    
    private ACME_Scoring_Criteria__mdt getScoringCriteria() {
        List<ACME_Scoring_Criteria__mdt> criteriaList = 
            [SELECT Engagement_Weight__c, Demographics_Weight__c 
             FROM ACME_Scoring_Criteria__mdt 
             LIMIT 1];
        
        return criteriaList.isEmpty() ? 
            new ACME_Scoring_Criteria__mdt(
                Engagement_Weight__c = 0.4, 
                Demographics_Weight__c = 0.6
            ) : criteriaList[0];
    }
    
    private Decimal calculateEngagementScore(Lead lead) {
        // Implement engagement scoring logic
        Decimal score = 0;
        
        if (lead.NumberOfEmployees != null) {
            score += Math.min(lead.NumberOfEmployees / 100, 30);
        }
        
        if (lead.Email != null) {
            score += 20;
        }
        
        return Math.min(score, 50);
    }
    
    private Decimal calculateDemographicsScore(Lead lead) {
        // Implement demographics scoring logic
        Decimal score = 0;
        
        if (lead.Industry != null) {
            score += 30;
        }
        
        if (lead.Country != null) {
            score += 20;
        }
        
        return Math.min(score, 50);
    }
}