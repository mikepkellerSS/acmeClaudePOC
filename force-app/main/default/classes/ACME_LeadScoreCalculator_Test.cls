@isTest
private class ACME_LeadScoreCalculator_Test {
    @isTest
    static void testLeadScoreCalculation() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            NumberOfEmployees = 150,
            Industry = 'Technology',
            HasOptedOutOfEmail = false
        );

        Test.startTest();
        Integer leadScore = ACME_LeadScoreCalculator.calculateLeadScore(testLead);
        Test.stopTest();

        System.assert(leadScore > 0, 'Lead score should be positive');
        System.assert(leadScore <= 100, 'Lead score should not exceed 100');
    }
}