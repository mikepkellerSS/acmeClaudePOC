@isTest
private class ACME_LeadScoringService_Test {
    
    @isTest
    static void testLeadScoreCalculation() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'test@example.com',
            Company = 'Test Company',
            NumberOfEmployees = 100,
            Industry = 'Technology',
            Title = 'Manager'
        );
        
        Test.startTest();
        Decimal score = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(score > 0, 'Lead score should be calculated');
        System.assert(score <= 100, 'Lead score should not exceed 100');
    }
    
    @isTest
    static void testLeadScoreUpdate() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test1',
                LastName = 'Lead1',
                Email = 'test1@example.com',
                Company = 'Test Company 1'
            ),
            new Lead(
                FirstName = 'Test2',
                LastName = 'Lead2',
                Email = 'test2@example.com',
                Company = 'Test Company 2'
            )
        };
        
        insert testLeads;
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();
        
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c, ACME_Last_Score_Calculation__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];
        
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be updated');
            System.assertNotEquals(null, lead.ACME_Last_Score_Calculation__c, 'Score calculation timestamp should be set');
        }
    }
}