/**
 * Test class for ACME_LeadScoringService
 * Ensures comprehensive test coverage and validates scoring logic
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Setup test data for lead scoring tests
     */
    @testSetup
    static void setupTestData() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Company = 'ACME Corp', 
                NumberOfEmployees = 150,
                Industry = 'Technology',
                LeadSource = 'Web'
            ),
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead2', 
                Company = 'Small Business', 
                NumberOfEmployees = 10,
                Industry = 'Retail',
                LeadSource = 'Referral'
            )
        };
        insert testLeads;
    }
    
    /**
     * Test lead scoring calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Retrieve test leads
        List<Lead> leads = [SELECT Id, NumberOfEmployees, Industry, LeadSource 
                            FROM Lead];
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(leads);
        Test.stopTest();
        
        // Retrieve updated leads
        leads = [SELECT ACME_LeadScore__c, ACME_LastScoredDate__c FROM Lead];
        
        // Assertions
        System.assertNotEquals(null, leads[0].ACME_LeadScore__c, 
            'Lead score should be calculated');
        System.assertNotEquals(null, leads[0].ACME_LastScoredDate__c, 
            'Last scored date should be set');
        
        // Additional score validation
        System.assert(leads[0].ACME_LeadScore__c > 0, 
            'Lead with target attributes should have positive score');
        System.assert(leads[1].ACME_LeadScore__c <= leads[0].ACME_LeadScore__c, 
            'Technology lead should score higher than retail lead');
    }
}