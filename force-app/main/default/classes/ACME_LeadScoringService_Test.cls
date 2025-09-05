@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            NumberOfEmployees = 500,
            Industry = 'Technology',
            Website_Visits__c = 10,
            Email_Interactions__c = 5
        );

        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        System.assert(leadScore >= 0 && leadScore <= 100, 
            'Lead score should be between 0 and 100');
    }

    @isTest
    static void testNullLeadScoring() {
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();

        System.assertEquals(0, leadScore, 'Null lead should return 0 score');
    }
}