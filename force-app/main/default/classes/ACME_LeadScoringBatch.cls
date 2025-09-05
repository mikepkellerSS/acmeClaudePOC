public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query leads that need score recalculation
        return Database.getQueryLocator([
            SELECT Id, NumberOfEmployees, Industry 
            FROM Lead 
            WHERE IsConverted = false
        ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        ACME_LeadScoringService.calculateLeadScore(scope);
        
        // Update leads with new scores
        update scope;
    }
    
    public void finish(Database.BatchableContext BC) {
        // Optional: Send completion notification
        System.debug('Lead Scoring Batch Job Completed');
    }
}