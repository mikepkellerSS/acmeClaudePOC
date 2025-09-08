@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Open'
        );
        insert testLead;

        // Create test metadata
        List<ACME_Scoring_Configuration__mdt> testConfigs = new List<ACME_Scoring_Configuration__mdt>();
        
        Test.startTest();
        ACMELeadScoringService.calculateLeadScore(new List<Lead>{testLead});
        Test.stopTest();

        // Retrieve updated lead
        Lead updatedLead = [SELECT Lead_Score__c FROM Lead WHERE Id = :testLead.Id];
        System.assertNotEquals(null, updatedLead.Lead_Score__c, 'Lead score should be calculated');
    }
}