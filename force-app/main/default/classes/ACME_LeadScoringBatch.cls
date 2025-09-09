/**
 * @description Batch job to recalculate lead scores periodically
 * @author ACME Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // Tracking batch job statistics
    private Integer totalProcessed = 0;
    private Integer totalScoresUpdated = 0;

    /**
     * Start method to select leads for batch processing
     * @param bc BatchableContext for batch job
     * @return Database.QueryLocator of leads to process
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query leads eligible for score recalculation
        return Database.getQueryLocator([
            SELECT Id, Email, NumberOfEmployees, Industry, 
                   Number_of_Website_Visits__c, HasOptedOutOfEmail
            FROM Lead
            WHERE IsConverted = false
            AND (ACME_Last_Score_Calculation__c = null 
                 OR ACME_Last_Score_Calculation__c < LAST_N_DAYS:30)
            WITH SECURITY_ENFORCED
        ]);
    }

    /**
     * Execute method to process each batch of leads
     * @param bc BatchableContext for batch job
     * @param scope List of leads to process in this batch
     */
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead leadRecord : scope) {
            Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(leadRecord);
            
            leadsToUpdate.add(new Lead(
                Id = leadRecord.Id,
                ACME_Lead_Score__c = calculatedScore,
                ACME_Last_Score_Calculation__c = System.now()
            ));

            totalProcessed++;
        }

        // Perform bulk update with FLS check
        if (!leadsToUpdate.isEmpty() && Schema.sObjectType.Lead.isUpdateable()) {
            List<Database.SaveResult> results = Database.update(leadsToUpdate, false);
            
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    totalScoresUpdated++;
                }
            }
        }
    }

    /**
     * Finish method to log batch job results
     * @param bc BatchableContext for batch job
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('Lead Scoring Batch Job Complete');
        System.debug('Total Leads Processed: ' + totalProcessed);
        System.debug('Total Scores Updated: ' + totalScoresUpdated);
    }
}