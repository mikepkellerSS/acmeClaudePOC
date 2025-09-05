public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query leads that need scoring update
        return Database.getQueryLocator([
            SELECT Id, Email, Title, Industry, NumberOfEmployees, 
                   HasOptedOutOfEmail, Country
            FROM Lead
            WHERE IsConverted = false
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        // Update lead scores in batches
        ACME_LeadScoringService.updateLeadScores(scope);
    }
    
    public void finish(Database.BatchableContext BC) {
        // Optional: Send completion notification or log results
        System.debug('Lead Scoring Batch Job Completed');
    }
    
    // Method to schedule the batch job
    public static void scheduleLeadScoring() {
        ACME_LeadScoringBatch batchJob = new ACME_LeadScoringBatch();
        String cronExpression = '0 0 1 * * ?'; // Run daily at 1 AM
        System.schedule('Daily Lead Scoring', cronExpression, batchJob);
    }
}