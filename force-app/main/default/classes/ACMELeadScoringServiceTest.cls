@isTest
private class ACMELeadScoringServiceTest {
    @TestSetup
    static void setupTestData() {
        // Create test metadata
        ACME_Scoring_Configuration__mdt testConfig = new ACME_Scoring_Configuration__mdt();
        testConfig.MasterLabel = 'Revenue Potential';
        testConfig.ACME_Weight__c = 1.0;
        testConfig.IsActive__c = true;
    }
    
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            AnnualRevenue = 100000
        );
        insert testLead;
        
        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assertNotEquals(null, score, 'Lead score should be calculated');
        System.assertEquals(100, score, 'Lead score calculation is incorrect');
    }
}