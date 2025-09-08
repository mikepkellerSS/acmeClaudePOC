/**
 * Batch process for recalculating lead scores in bulk
 * @author ACME Development Team
 * @date 2024-02-15
 * @description Handles bulk lead score recalculation
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext for batch job
     * @return Database.QueryLocator with leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Email, Company, Title, Industry, 
                   NumberOfEmployees, HasOptedOutOfEmail
            FROM Lead
            WHERE IsConverted = false
        ]);
    }
    
    /**
     * Execute method to process leads and update scores
     * @param bc BatchableContext for batch job
     * @param leads List of leads to process in this batch
     */
    public void execute(Database.BatchableContext bc, List<Lead> leads) {
        ACME_LeadScoringService.updateLeadScores(leads);
    }
    
    /**
     * Finish method for any post-processing tasks
     * @param bc BatchableContext for batch job
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Send completion notification or log results
        System.debug('Lead Scoring Batch Job Completed');
    }
}