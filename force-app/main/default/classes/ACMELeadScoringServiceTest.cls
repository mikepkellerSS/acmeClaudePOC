@isTest
private class ACMELeadScoringServiceTest {
    @TestSetup
    static void setupTestData() {
        // Create a default scoring configuration
        List<ACME_Scoring_Configuration__mdt> configs = 
            [SELECT Id FROM ACME_Scoring_Configuration__mdt WHERE IsActive__c = true];
        System.assert(!configs.isEmpty(), 'Test requires an active scoring configuration');
    }
    
    @isTest
    static void testLeadScoring() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Email = 'test@example.com',
                Phone = '1234567890',
                Company = 'Test Company'
            ),
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead2',
                Email = null,
                Phone = null,
                Company = null
            )
        };
        
        Test.startTest();
        List<Lead> scoredLeads = ACMELeadScoringService.scoreLead(testLeads);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, scoredLeads[0].Score__c, 'First lead score should be calculated');
        System.assert(scoredLeads[0].Score__c > 0, 'First lead score should be positive');
        
        System.assertNotEquals(null, scoredLeads[1].Score__c, 'Second lead score should be calculated');
        System.assertEquals(0, scoredLeads[1].Score__c, 'Second lead score should be zero');
    }
    
    @isTest
    static void testEmptyLeadList() {
        List<Lead> emptyLeads = new List<Lead>();
        
        Test.startTest();
        List<Lead> result = ACMELeadScoringService.scoreLead(emptyLeads);
        Test.stopTest();
        
        System.assertEquals(0, result.size(), 'Empty list should remain empty');
    }
}