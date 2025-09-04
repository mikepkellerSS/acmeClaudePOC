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
                Email = 'test@example.com',
                Title = 'Manager',
                NumberOfEmployees = 500,
                AnnualRevenue = 2000000
            )
        };

        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(testLeads);
        Test.stopTest();

        // Assertions
        System.assert(testLeads[0].ACME_Lead_Score__c != null, 'Lead score should be calculated');
        System.assert(testLeads[0].ACME_Lead_Score__c >= 0 && testLeads[0].ACME_Lead_Score__c <= 100, 'Score should be between 0-100');
        System.assertEquals('High', testLeads[0].ACME_Lead_Engagement_Level__c, 'Engagement level should be High');
    }
}