public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Company, Industry, LastName, Status 
            FROM Lead 
            WHERE ACME_Lead_Score__c = null
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead leadRecord : scope) {
            Decimal leadScore = ACMELeadScoringService.calculateLeadScore(leadRecord);
            leadRecord.ACME_Lead_Score__c = leadScore;
            leadsToUpdate.add(leadRecord);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Optional: Send completion notification or perform post-batch processing
    }
}