/**
 * @description Batch process for mass lead rescoring
 * @author Studio Science
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    private Integer totalProcessed = 0;
    private Integer totalScored = 0;
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, NumberOfEmployees, Industry, Title, Country, 
                   ACME_Lead_Score__c, ACME_Last_Scored_Date__c
            FROM Lead
            WHERE IsConverted = false
            AND Status != 'Closed - Converted'
        ]);
    }
    
    /**
     * Execute method to process each batch of leads
     * @param bc BatchableContext
     * @param scope List of leads in current batch
     */
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : scope) {
            totalProcessed++;
            
            Integer newScore = ACME_LeadScoringService.calculateLeadScore(lead);
            
            if (lead.ACME_Lead_Score__c != newScore) {
                lead.ACME_Lead_Score__c = newScore;
                lead.ACME_Last_Scored_Date__c = System.now();
                leadsToUpdate.add(lead);
                totalScored++;
            }
        }
        
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
    
    /**
     * Finish method to log batch processing results
     * @param bc BatchableContext
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('Lead Scoring Batch Complete');
        System.debug('Total Leads Processed: ' + totalProcessed);
        System.debug('Total Leads Rescored: ' + totalScored);
        
        // Optional: Send completion notification
        sendCompletionNotification();
    }
    
    /**
     * Send notification about batch processing completion
     */
    private void sendCompletionNotification() {
        // Implement notification logic (e.g., email, platform event)
    }
}