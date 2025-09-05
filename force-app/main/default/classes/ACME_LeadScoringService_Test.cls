@isTest
private class ACME_LeadScoringService_Test {
    
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            LeadSource = 'Marketing Campaign'
        );
        
        // Calculate score
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        // Assertions
        System.assertEquals(60, score, 'Lead score calculation incorrect');
    }
    
    @isTest
    static void testBulkLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test1',
                LastName = 'Lead1',
                Company = 'Company1',
                Email = 'test1@example.com'
            ),
            new Lead(
                FirstName = 'Test2', 
                LastName = 'Lead2',
                Company = 'Company2'
            )
        };
        
        // Score leads
        List<Lead> scoredLeads = ACME_LeadScoringService.scoreBulkLeads(testLeads);
        
        // Assertions
        System.assertEquals(2, scoredLeads.size(), 'Bulk scoring failed');
        System.assertNotEquals(null, scoredLeads[0].ACME_Lead_Score__c, 'Score not calculated');
    }
}