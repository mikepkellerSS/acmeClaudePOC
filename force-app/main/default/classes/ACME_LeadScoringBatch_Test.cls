/**
 * @description Test class for Lead Scoring Batch Job
 * @author Studio Science
 * @date 2025-09-06
 */
@isTest
private class ACME_LeadScoringBatch_Test {
    
    @testSetup
    static void setupTestData() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'BatchLead ' + i,
                Company = 'Test Company ' + i,
                Status = 'Open - Not Contacted',
                ACME_Last_Engagement_Date__c = System.today().addDays(-i)
            ));
        }
        insert testLeads;
    }

    @isTest
    static void testLeadScoringBatch() {
        Test.startTest();
        ACME_LeadScoringBatch batchJob = new ACME_LeadScoringBatch();
        Database.executeBatch(batchJob, 200);
        Test.stopTest();

        // Verify leads were processed
        List<Lead> processedLeads = [
            SELECT Id, ACME_Lead_Score__c 
            FROM Lead 
            WHERE LastName LIKE 'BatchLead%'
        ];

        System.assertNotEquals(0, processedLeads.size(), 'Leads should be processed');
        
        for (Lead lead : processedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 
                'Lead score should be calculated');
            System.assert(lead.ACME_Lead_Score__c >= 0 && lead.ACME_Lead_Score__c <= 100, 
                'Lead score should be between 0 and 100');
        }
    }
}