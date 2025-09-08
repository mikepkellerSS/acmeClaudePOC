@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Industry = 'Technology',
            NumberOfEmployees = 500,
            AnnualRevenue = 1000000
        );
        
        Test.startTest();
        Integer leadScore = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(leadScore > 0, 'Lead score should be greater than zero');
    }
}