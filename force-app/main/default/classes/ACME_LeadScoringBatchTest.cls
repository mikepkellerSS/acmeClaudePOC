/**
 * @description Test class for ACME_LeadScoringBatch
 * @author ACME Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringBatchTest {
    
    /**
     * Setup test data for batch job testing
     */
    @testSetup
    static void createTestLeads() {
        List<Lead> testLeads = new List<Lead>();
        
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Email = 'test' + i + '@example.com',
                NumberOfEmployees = 100 + i,
                Industry = 'Technology'
            ));
        }
        
        insert testLeads;
    }
    
    /**
     * Test batch job lead scoring functionality
     */
    @isTest
    static void testLeadScoringBatch() {
        Test.startTest();
        ACME_LeadScoringBatch batchJob = new ACME_LeadScoringBatch();
        Database.executeBatch(batchJob, 200);
        Test.stopTest();
        
        // Verify leads were scored
        List<Lead> processedLeads = [
            SELECT Id, ACME_Lead_Score__c, ACME_Last_Score_Calculation__c 
            FROM Lead 
            WHERE ACME_Lead_Score__c != null
        ];
        
        System.assertNotEquals(0, processedLeads.size(), 'Leads should have been scored');
        
        for (Lead lead : processedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be calculated');
            System.assertNotEquals(null, lead.ACME_Last_Score_Calculation__c, 'Calculation timestamp should be set');
        }
    }
}