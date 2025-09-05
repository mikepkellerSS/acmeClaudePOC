/**
 * Batch class for processing lead scoring in bulk
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    /**
     * Start method to define the scope of leads to process
     * 
     * @param BC BatchableContext
     * @return QueryLocator for leads to be scored
     */
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Ensure we have read access to lead object
        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new System.NoAccessException('No access to Lead object');
        }
        
        return Database.getQueryLocator([
            SELECT Id, Email, Company, LeadSource 
            FROM Lead 
            WHERE IsConverted = false
        ]);
    }
    
    /**
     * Execute method to process each batch of leads
     * 
     * @param BC BatchableContext
     * @param scope List of leads in current batch
     */
    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        // Ensure we have update access
        if (!Schema.sObjectType.Lead.isUpdateable()) {
            throw new System.NoAccessException('No update access to Lead object');
        }
        
        List<Lead> leadsToUpdate = ACME_LeadScoringService.scoreBulkLeads(scope);
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
    
    /**
     * Finish method for any post-processing
     * 
     * @param BC BatchableContext
     */
    public void finish(Database.BatchableContext BC) {
        System.debug(LoggingLevel.INFO, 'Lead Scoring Batch Job Completed');
    }
}