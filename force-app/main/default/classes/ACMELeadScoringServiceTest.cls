@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1', 
                Company = 'Test Company',
                Status = 'Open'
            )
        };
        
        // Insert test leads
        insert testLeads;
        
        // Create test metadata
        List<ACME_Scoring_Configuration__mdt> testConfigs = new List<ACME_Scoring_Configuration__mdt>();
        
        // Run scoring
        Test.startTest();
        List<Decimal> scores = ACMELeadScoringService.getLeadScores(testLeads);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, scores.size(), 'Should return scores for all leads');
        System.assertNotEquals(null, scores[0], 'Score should not be null');
    }
}