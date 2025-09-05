/**
 * Batch job to recalculate lead scores in bulk
 */
public with sharing class ACME_LeadScoreBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // Batch job tracking
    private Integer totalProcessed = 0;
    private Integer totalSuccessful = 0;
    
    /**
     * Query all leads to be scored
     * @param bc Batch context
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query leads that might need scoring
        return Database.getQueryLocator([
            SELECT Id 
            FROM Lead 
            WHERE IsConverted = false 
            AND (ACME_Lead_Score__c = null OR ACME_Score_Last_Updated__c < LAST_N_DAYS:30)
        ]);
    }
    
    /**
     * Process each batch of leads
     * @param bc Batch context
     * @param scope List of leads to process
     */
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Lead> leadsToProcess = (List<Lead>)scope;
        
        for (Lead lead : leadsToProcess) {
            try {
                ACME_LeadScoreHandler.calculateLeadScore(lead.Id);
                totalSuccessful++;
            } catch (Exception e) {
                // Log individual lead processing errors
                System.debug(LoggingLevel.ERROR, 'Error processing lead ' + lead.Id + ': ' + e.getMessage());
            }
            totalProcessed++;
        }
    }
    
    /**
     * Finish batch job and log results
     * @param bc Batch context
     */
    public void finish(Database.BatchableContext bc) {
        // Send notification or log batch results
        System.debug(LoggingLevel.INFO, 'Lead Scoring Batch Job Complete');
        System.debug(LoggingLevel.INFO, 'Total Leads Processed: ' + totalProcessed);
        System.debug(LoggingLevel.INFO, 'Total Leads Successfully Scored: ' + totalSuccessful);
    }
    
    /**
     * Convenience method to start the batch job
     */
    public static void runBatch() {
        Database.executeBatch(new ACME_LeadScoreBatch(), 200);
    }
}