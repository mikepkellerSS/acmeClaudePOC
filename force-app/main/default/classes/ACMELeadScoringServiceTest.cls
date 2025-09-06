@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            NumberOfEmployees = 100,
            AnnualRevenue = 500000
        );

        // Instantiate service
        ACMELeadScoringService scoringService = new ACMELeadScoringService();

        // Perform test
        Integer score = scoringService.calculateLeadScore(testLead);
        Boolean isQualified = scoringService.isQualifiedLead(score);

        // Assertions
        System.assert(score > 0, 'Score should be calculated');
        System.assert(isQualified, 'Lead should be qualified');
    }

    @isTest
    static void testNullLeadScoring() {
        // Create test lead with null values
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp'
        );

        // Instantiate service
        ACMELeadScoringService scoringService = new ACMELeadScoringService();

        // Perform test
        Integer score = scoringService.calculateLeadScore(testLead);

        // Assertions
        System.assertEquals(0, score, 'Score should be zero for null values');
    }
}