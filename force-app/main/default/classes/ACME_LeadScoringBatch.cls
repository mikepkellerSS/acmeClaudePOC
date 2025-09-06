/**
 * @description Batch job for processing lead scores
 * @author Studio Science
 * @date 2025-09-06
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject> {
    
    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query leads that need scoring
        return Database.getQueryLocator([
            SELECT Id, Company, ACME_Last_Engagement_Date__c 
            FROM Lead 
            WHERE ACME_Lead_Score__c = null 
               OR ACME_Last_Engagement_Date__c != null
            LIMIT 10000
        ]);
    }

    /**
     * Execute method to process leads in batches
     * @param bc BatchableContext
     * @param scope List of leads to process
     */
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        // Calculate lead scores
        ACME_LeadScoringService.calculateLeadScore(scope);
        
        // Perform update with proper error handling
        List<Database.SaveResult> saveResults = Database.update(scope, false);
        
        // Log any errors
        for (Database.SaveResult sr : saveResults) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    System.debug(LoggingLevel.ERROR, 
                        'Lead scoring update failed: ' + err.getStatusCode() + 
                        ' - ' + err.getMessage());
                }
            }
        }
    }

    /**
     * Finish method for any post-processing
     * @param bc BatchableContext
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Send completion notification or schedule next batch
        System.debug(LoggingLevel.INFO, 'Lead Scoring Batch Job Completed');
    }
}