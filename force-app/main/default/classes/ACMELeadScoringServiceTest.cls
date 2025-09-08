@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testCalculateLeadScore() {
        // Create test lead
        Lead testLead = new Lead(
            Company = 'Test Company',
            Industry = 'Technology',
            LastName = 'Test Lead',
            Status = 'Open'
        );
        insert testLead;

        Test.startTest();
        Decimal leadScore = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        System.assertNotEquals(null, leadScore, 'Lead score should not be null');
    }
}