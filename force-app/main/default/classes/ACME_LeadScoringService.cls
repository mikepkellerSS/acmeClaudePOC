public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        try {
            // Retrieve scoring criteria
            List<ACME_Scoring_Criteria__mdt> scoringCriteria = 
                [SELECT Score_Type__c, Criteria_Field__c, 
                        Minimum_Value__c, Maximum_Value__c, Score_Points__c 
                 FROM ACME_Scoring_Criteria__mdt];
            
            // Process each lead
            for (Lead lead : leads) {
                Decimal totalScore = 0;
                
                for (ACME_Scoring_Criteria__mdt criteria : scoringCriteria) {
                    Object fieldValue = getFieldValue(lead, criteria.Criteria_Field__c);
                    
                    if (isValueInRange(fieldValue, criteria)) {
                        totalScore += criteria.Score_Points__c;
                    }
                }
                
                // Update lead score
                lead.ACME_Lead_Score__c = totalScore;
            }
        } catch (Exception e) {
            // Robust error logging
            System.debug('Lead Scoring Error: ' + e.getMessage());
            LogService.logError('ACME_LeadScoringService', e);
        }
    }
    
    private static Object getFieldValue(SObject record, String fieldName) {
        try {
            return record.get(fieldName);
        } catch (Exception e) {
            System.debug('Field Access Error: ' + fieldName);
            return null;
        }
    }
    
    private static Boolean isValueInRange(Object value, ACME_Scoring_Criteria__mdt criteria) {
        if (value == null) return false;
        
        try {
            Decimal numValue = Decimal.valueOf(String.valueOf(value));
            
            Boolean minCheck = criteria.Minimum_Value__c == null || 
                               numValue >= criteria.Minimum_Value__c;
            Boolean maxCheck = criteria.Maximum_Value__c == null || 
                               numValue <= criteria.Maximum_Value__c;
            
            return minCheck && maxCheck;
        } catch (Exception e) {
            return false;
        }
    }
}