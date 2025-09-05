@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'ACME Corp',
                Title = 'Director',
                Email = 'test@example.com',
                NumberOfEmployees = 200
            )
        };
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(testLeads);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(90, testLeads[0].ACME_Lead_Score__c, 
            'Lead score calculation incorrect');
        System.assertNotEquals(null, testLeads[0].ACME_Last_Score_Calculation__c, 
            'Calculation timestamp not set');
    }
}