/**
 * @description Service layer for lead scoring operations
 * @author Salesforce Architect
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoreService {
    /**
     * Update lead score for a collection of leads
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        try {
            for (Lead lead : leads) {
                lead.ACME__Lead_Score__c = ACME_LeadScoreCalculator.calculateLeadScore(lead);
            }
            update leads;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_LeadScoreService', 'updateLeadScores', e);
        }
    }

    /**
     * Retrieve lead scoring metrics from custom metadata
     * @return List of lead scoring metrics
     */
    public static List<ACME__LeadScoreMetric__mdt> getLeadScoringMetrics() {
        return [SELECT 
            ACME__Criteria__c, 
            ACME__Weight__c, 
            ACME__Max_Score__c 
            FROM ACME__LeadScoreMetric__mdt];
    }
}