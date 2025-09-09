public with sharing class ACME_LeadScoringService {
    public static void scoreLead(List<Lead> leads) {
        // Retrieve lead scoring criteria from custom metadata
        List<ACME_LeadScoringCriteria__mdt> scoringCriteria = 
            [SELECT Field__c, ScoreType__c, Weight__c 
             FROM ACME_LeadScoringCriteria__mdt];
        
        for (Lead lead : leads) {
            Decimal totalScore = 0;
            
            for (ACME_LeadScoringCriteria__mdt criteria : scoringCriteria) {
                Object fieldValue = lead.get(criteria.Field__c);
                
                if (fieldValue != null) {
                    if (criteria.ScoreType__c == 'Numeric') {
                        Decimal numericValue = Decimal.valueOf(String.valueOf(fieldValue));
                        totalScore += numericValue * (criteria.Weight__c != null ? criteria.Weight__c : 1);
                    } else if (criteria.ScoreType__c == 'Boolean') {
                        Boolean boolValue = Boolean.valueOf(fieldValue);
                        totalScore += boolValue ? (criteria.Weight__c != null ? criteria.Weight__c : 1) : 0;
                    }
                }
            }
            
            lead.ACME_LeadScore__c = totalScore;
            lead.ACME_LastScoredDate__c = System.now();
        }
    }
}