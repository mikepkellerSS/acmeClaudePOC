/**
 * @description Batch job to recalculate lead scores in bulk
 * @author Studio Science
 * @date 2025-09-09
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Company, 
                   NumberOfEmployees, LeadSource, 
                   Industry, Title
            FROM Lead
            WHERE IsConverted = false
            LIMIT 10000
        ]);
    }

    /**
     * Execute method to process leads in batches
     * @param bc BatchableContext
     * @param leads List of leads to process
     */
    public void execute(Database.BatchableContext bc, List<Lead> leads) {
        ACME_LeadScoringService.updateLeadScores(leads);
    }

    /**
     * Finish method for any post-processing
     * @param bc BatchableContext
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Send completion notification or log results
        System.debug('Lead scoring batch job completed');
    }
}