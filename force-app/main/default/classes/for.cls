/**
 * Batch class for mass lead scoring recalculation
 * Handles bulk lead scoring updates
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject>, Finalizer {
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext for batch job
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Industry, NumberOfEmployees, 
                   Website_Visits__c, Email_Opens__c 
            FROM Lead 
            WHERE IsConverted = false
        ]);
    }
    
    /**
     * Execute method to process each batch of leads
     * @param bc BatchableContext for batch job
     * @param leads List of leads in current batch
     */
    public void execute(Database.BatchableContext bc, List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Decimal score = ACME_LeadScoringService.calculateLeadScore(lead);
            lead.ACME_Lead_Score__c = score;
            lead.ACME_Last_Scored_Date__c = System.now();
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
    
    /**
     * Finish method for batch job
     * @param bc BatchableContext for batch job
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('Lead scoring batch job completed');
    }
    
    /**
     * Finalizer method for tracking job completion
     * @param context Context of the finalizer
     */
    public void execute(FinalizerContext context) {
        // Optional additional processing or logging
        System.debug('Batch job finalizer executed');
    }
}