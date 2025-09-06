@isTest
private class ACME_LeadScoringService_Test {
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

        // Run the scoring method
        Test.startTest();
        Decimal score = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert the score
        System.assertNotEquals(null, score, 'Score should not be null');
        System.assert(score > 0, 'Score should be greater than 0');
    }
}