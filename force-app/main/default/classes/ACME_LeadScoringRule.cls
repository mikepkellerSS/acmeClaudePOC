public with sharing class ACME_LeadScoringRule {
    public static List<ACME_Lead_Scoring_Rule__mdt> getActiveRules() {
        try {
            return [
                SELECT MasterLabel, 
                       Weight__c, 
                       Calculation_Logic__c 
                FROM ACME_Lead_Scoring_Rule__mdt 
                WHERE Is_Active__c = true 
                ORDER BY Weight__c DESC
            ];
        } catch (Exception e) {
            System.debug('Error retrieving scoring rules: ' + e.getMessage());
            return new List<ACME_Lead_Scoring_Rule__mdt>();
        }
    }
}