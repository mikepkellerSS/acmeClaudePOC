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
            Email = 'test@example.com'
        );
        
        // Calculate score
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        // Assert score is within expected range
        System.assert(score >= 0 && score <= 100, 'Score should be between 0-100');
    }
}