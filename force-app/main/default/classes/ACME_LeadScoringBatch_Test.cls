/**
 * @description Test class for Lead Scoring Batch job
 * @author Studio Science
 * @date 2025-09-09
 */
@isTest
private class ACME_LeadScoringBatch_Test {
    
    /**
     * Test batch lead scoring job
     */
    @isTest
    static void testLeadScoringBatch() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Batch ' + i,
                Company = 'Test Company ' + i,
                NumberOfEmployees = 50 + i,
                LeadSource = 'Web'
            ));
        }
        insert testLeads;

        Test.startTest();
        ACME_LeadScoringBatch batchJob = new ACME_LeadScoringBatch();
        Database.executeBatch(batchJob, 200);
        Test.stopTest();

        // Verify leads were processed
        List<Lead> processedLeads = [
            SELECT Id, ACME_Lead_Score__c, ACME_Last_Score_Calculation__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];

        System.assertEquals(testLeads.size(), processedLeads.size(), 'All leads should be processed');
        
        for (Lead lead : processedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be calculated');
            System.assertNotEquals(null, lead.ACME_Last_Score_Calculation__c, 'Score calculation timestamp should be set');
        }
    }
}