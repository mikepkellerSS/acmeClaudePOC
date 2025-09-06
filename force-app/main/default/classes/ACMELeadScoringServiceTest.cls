@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Industry = 'Technology'
        );
        insert testLead;
        
        // Create test metadata
        ACME_Scoring_Configuration__mdt testConfig = new ACME_Scoring_Configuration__mdt(
            MasterLabel = 'Industry',
            ACME_Weight__c = 0.5
        );
        
        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(score > 0, 'Lead score should be calculated');
    }
}