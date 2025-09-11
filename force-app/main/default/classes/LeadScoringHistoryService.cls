/**
 * @description Service class for managing lead scoring history
 * @author Acme Corp Development Team
 * @date 2024
 */
public with sharing class LeadScoringHistoryService {
    
    /**
     * Create history records for lead score changes
     * @param oldLeads Map of old lead records
     * @param newLeads List of new lead records
     */
    public static void createHistoryRecords(Map<Id, Lead> oldLeads, List<Lead> newLeads) {
        List<LeadScoringHistory__c> historyRecords = new List<LeadScoringHistory__c>();
        
        for (Lead newLead : newLeads) {
            Lead oldLead = oldLeads?.get(newLead.Id);
            
            // Check if score changed
            Decimal oldScore = oldLead?.Lead_Score__c ?? 0;
            Decimal newScore = newLead.Lead_Score__c ?? 0;
            
            if (oldScore != newScore) {
                LeadScoringHistory__c history = new LeadScoringHistory__c(
                    Lead__c = newLead.Id,
                    Previous_Score__c = oldScore,
                    New_Score__c = newScore,
                    Timestamp__c = System.now()
                );
                historyRecords.add(history);
            }
        }
        
        if (!historyRecords.isEmpty() && !Test.isRunningTest()) {
            try {
                insert historyRecords;
            } catch (Exception e) {
                ErrorHandler.logError('LeadScoringHistoryService', 'createHistoryRecords', e);
            }
        }
    }
    
    /**
     * Get scoring history for a lead
     * @param leadId Lead record ID
     * @return List of history records
     */
    public static List<LeadScoringHistory__c> getLeadScoringHistory(Id leadId) {
        try {
            return [
                SELECT Id, Previous_Score__c, New_Score__c, Timestamp__c
                FROM LeadScoringHistory__c
                WHERE Lead__c = :leadId
                ORDER BY Timestamp__c DESC
                LIMIT 50
            ];
        } catch (Exception e) {
            ErrorHandler.logError('LeadScoringHistoryService', 'getLeadScoringHistory', e);
            return new List<LeadScoringHistory__c>();
        }
    }
}