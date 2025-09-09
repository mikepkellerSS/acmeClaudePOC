/**
 * @description Batch process to update lead scores in bulk
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, ACME_Lead_Score__c 
            FROM Lead 
            WHERE IsConverted = false
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
            Integer newScore = ACME_LeadScoringService.calculateLeadScore(lead);
            
            lead.ACME_Lead_Score__c = newScore;
            lead.ACME_Last_Scored_Date__c = System.now();
            
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
    
    /**
     * Finish method for any post-processing
     * @param bc BatchableContext
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Send completion notification or log results
        System.debug('Lead Scoring Batch Job Completed');
    }
}