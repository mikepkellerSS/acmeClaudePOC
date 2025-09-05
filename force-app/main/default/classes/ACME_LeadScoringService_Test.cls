@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            NumberOfEmployees = 150,
            Email = 'test@example.com',
            Industry = 'Technology'
        );
        insert testLead;

        // Run scoring calculation
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(new List<Lead>{testLead});
        Test.stopTest();

        // Retrieve updated lead
        Lead updatedLead = [SELECT ACME_Engagement_Score__c, 
                                   ACME_Demographic_Score__c, 
                                   ACME_Lead_Score__c 
                            FROM Lead 
                            WHERE Id = :testLead.Id];

        // Assertions
        System.assert(updatedLead.ACME_Engagement_Score__c > 0, 'Engagement score should be calculated');
        System.assert(updatedLead.ACME_Demographic_Score__c > 0, 'Demographic score should be calculated');
        System.assert(updatedLead.ACME_Lead_Score__c > 0, 'Total lead score should be calculated');
    }
}