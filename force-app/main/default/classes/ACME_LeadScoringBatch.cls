public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query leads that need scoring update
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Email, Title, 
                   NumberOfEmployees, AnnualRevenue
            FROM Lead
            WHERE IsConverted = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        ACME_LeadScoringService.calculateLeadScore(scope);
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        // Optional: Send completion notification
        System.debug('Lead Scoring Batch Job Completed');
    }
}