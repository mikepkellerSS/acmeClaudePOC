@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            NumberOfEmployees = 500,
            Industry = 'Technology',
            HasOptedOutOfEmail = false
        );
        
        Test.startTest();
        List<Lead> leads = new List<Lead>{testLead};
        ACME_LeadScoringService.calculateLeadScore(leads);
        Test.stopTest();
        
        // Assertions
        System.assert(testLead.ACME_Lead_Score__c > 0, 'Lead score should be calculated');
        System.assertNotEquals(null, testLead.ACME_Last_Scored_Date__c, 'Scoring date should be set');
    }
}