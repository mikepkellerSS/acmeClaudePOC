@isTest
private class ACME_LeadScoringService_Test {
    
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Title = 'Director',
            NumberOfEmployees = 100,
            HasOptedOutOfEmail = false
        );
        
        Test.startTest();
        Decimal score = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(score > 0, 'Lead score should be positive');
        System.assert(score <= 100, 'Lead score should not exceed 100');
    }
    
    @isTest
    static void testLeadScoreUpdate() {
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1',
                Company = 'ACME Corp',
                Title = 'Manager'
            )
        };
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();
        
        System.assertNotEquals(null, testLeads[0].ACME_Lead_Score__c, 'Lead score should be calculated');
    }
}