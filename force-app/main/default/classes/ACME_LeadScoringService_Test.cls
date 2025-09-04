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
                NumberOfFormSubmissions__c = 3,
                Company_Size__c = 'Enterprise'
            )
        };
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(testLeads);
        Test.stopTest();
        
        // Assert scores calculated
        System.assertNotEquals(null, testLeads[0].ACME_Lead_Score__c);
        System.assert(testLeads[0].ACME_Lead_Score__c > 0);
    }
}