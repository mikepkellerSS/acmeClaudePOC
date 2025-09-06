@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Number_of_Employees__c = 25
        );
        insert testLead;

        // Create test metadata
        ACME_Scoring_Configuration__mdt mockConfig = new ACME_Scoring_Configuration__mdt(
            MasterLabel = 'Number of Employees',
            ACME_Weight__c = 2
        );

        // Run the scoring method
        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert the score
        System.assertNotEquals(null, score, 'Score should not be null');
        System.assert(score > 0, 'Score should be greater than 0');
    }
}