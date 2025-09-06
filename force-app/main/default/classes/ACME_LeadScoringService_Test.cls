@isTest
private class ACME_LeadScoringService_Test {
    
    @isTest
    static void testLeadScoring() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            NumberOfEmployees = 250,
            Industry = 'Technology',
            Country = 'United States'
        );
        
        Test.startTest();
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(score > 0 && score <= 100, 'Score should be between 0-100');
    }
}