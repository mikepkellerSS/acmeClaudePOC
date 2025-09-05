@isTest
private class ACME_LeadScoringService_TEST {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead', 
                Company = 'ACME Corp', 
                NumberOfEmployees = 200,
                Industry = 'Technology'
            )
        };
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(testLeads);
        Test.stopTest();
        
        // Assert expected behavior
        System.assert(testLeads[0].ACME_Lead_Score__c > 0, 'Lead score should be calculated');
        System.assertNotEquals(null, testLeads[0].ACME_Last_Score_Calculation__c, 'Calculation timestamp should be set');
    }
}