@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company'
        );
        insert testLead;

        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        System.assertNotEquals(null, score, 'Score should be calculated');
    }
}