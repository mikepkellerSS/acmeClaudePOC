@isTest
private class ACME_LeadScoringService_Test {
    @testSetup
    static void setupTestData() {
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1', 
                Company = 'ACME Corp',
                Industry = 'Technology',
                NumberOfEmployees = 500
            ),
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead2',
                Company = 'Small Business',
                Industry = null,
                NumberOfEmployees = 10
            )
        };
        insert testLeads;
    }
    
    @isTest
    static void testLeadScoreCalculation() {
        List<Lead> testLeads = [SELECT Id, ACME_Lead_Score__c FROM Lead];
        
        System.assertNotEquals(null, testLeads[0].ACME_Lead_Score__c, 
            'Lead score should be calculated');
    }
    
    @isTest
    static void testEdgeCaseScoring() {
        Lead testLead = new Lead(
            FirstName = 'Edge', 
            LastName = 'Case',
            Company = 'Test Company'
        );
        
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        System.assert(score >= 0 && score <= 100, 
            'Score should be between 0 and 100');
    }
}