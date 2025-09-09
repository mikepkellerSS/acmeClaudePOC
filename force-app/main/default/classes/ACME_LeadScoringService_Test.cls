@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'Test Company',
                AnnualRevenue = 500000,
                NumberOfEmployees = 50
            )
        };
        
        insert testLeads;
        
        Test.startTest();
        ACME_LeadScoringService.scoreLead(testLeads);
        Test.stopTest();
        
        // Retrieve updated leads
        List<Lead> updatedLeads = [
            SELECT ACME_LeadScore__c, ACME_LastScoredDate__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];
        
        // Assert that lead score and last scored date are populated
        System.assertNotEquals(null, updatedLeads[0].ACME_LeadScore__c, 'Lead score should be calculated');
        System.assertNotEquals(null, updatedLeads[0].ACME_LastScoredDate__c, 'Last scored date should be set');
    }
}