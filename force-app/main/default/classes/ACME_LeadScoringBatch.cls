public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Company, 
                   NumberOfFormSubmissions__c, Company_Size__c 
            FROM Lead 
            WHERE IsConverted = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        ACME_LeadScoringService.calculateLeadScore(scope);
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Lead Scoring Batch Completed');
    }
}