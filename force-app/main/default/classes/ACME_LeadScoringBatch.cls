/**
 * @description Batch class for processing lead scoring
 * @author Studio Science
 * @date 2025-09-05
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // Query leads to be processed
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Company, Industry 
            FROM Lead 
            WHERE IsConverted = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        // Calculate lead scores for the batch
        ACME_LeadScoringService.calculateLeadScore(scope);
        
        // Perform update
        try {
            update scope;
        } catch (Exception e) {
            // Log error
            System.debug('Error updating leads: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Optional: Send completion notification
        System.debug('Lead scoring batch job completed');
    }
}