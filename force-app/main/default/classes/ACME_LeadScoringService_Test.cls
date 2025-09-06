@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open - Not Contacted'
        );
        insert testLead;

        // Run lead scoring
        Test.startTest();
        ACME_LeadScoringService.scoreLeads(new List<Lead>{testLead});
        Test.stopTest();

        // Retrieve updated lead
        Lead updatedLead = [SELECT Id, Lead_Score__c FROM Lead WHERE Id = :testLead.Id];
        
        // Assert lead score is calculated
        System.assertNotEquals(null, updatedLead.Lead_Score__c, 'Lead score should be calculated');
    }
}