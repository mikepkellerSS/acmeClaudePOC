/**
 * Batch class for processing lead scoring in bulk
 */
public with sharing class ACMELeadScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext for batch execution
     * @return QueryLocator with leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id 
            FROM Lead 
            WHERE IsConverted = false 
            WITH SECURITY_ENFORCED
        ]);
    }
    
    /**
     * Execute method to process individual lead batches
     * @param bc BatchableContext for batch execution
     * @param scope List of leads to process
     */
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : scope) {
            try {
                Decimal score = ACMELeadScoringService.calculateLeadScore(lead.Id);
                leadsToUpdate.add(new Lead(
                    Id = lead.Id,
                    ACME_Lead_Score__c = score,
                    ACME_Last_Scored_Timestamp__c = System.now()
                ));
            } catch (Exception e) {
                // Log error for individual lead processing
                System.debug('Error processing lead ' + lead.Id + ': ' + e.getMessage());
            }
        }
        
        // Perform bulk update with security check
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
    
    /**
     * Finish method for any post-processing tasks
     * @param bc BatchableContext for batch execution
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Send completion notification or log
        System.debug('Lead Scoring Batch Job Completed');
    }
}