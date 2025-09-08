/**
 * Service class for retrieving Lead Scoring Rules from Custom Metadata
 */
public with sharing class ACME_LeadScoringRule {
    /**
     * Retrieves active lead scoring rules from Custom Metadata
     * @return List of active Lead Scoring Rules
     */
    public static List<ACME_Lead_Scoring_Rule__mdt> getActiveRules() {
        try {
            return [
                SELECT Metric_Name__c, 
                       Weight__c, 
                       Calculation_Logic__c 
                FROM ACME_Lead_Scoring_Rule__mdt 
                WHERE Is_Active__c = true 
                ORDER BY Weight__c DESC
            ];
        } catch (Exception e) {
            // Log error and return empty list to prevent scoring failure
            System.Logger.error('Error retrieving scoring rules: ' + e.getMessage());
            return new List<ACME_Lead_Scoring_Rule__mdt>();
        }
    }
}