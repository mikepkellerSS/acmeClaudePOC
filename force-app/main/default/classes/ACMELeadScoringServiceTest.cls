@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testCalculateLeadScore() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890'
        );

        // Create mock metadata records
        List<ACME_Scoring_Configuration__mdt> mockConfigs = new List<ACME_Scoring_Configuration__mdt>();
        
        ACME_Scoring_Configuration__mdt emailConfig = new ACME_Scoring_Configuration__mdt();
        emailConfig.MasterLabel = 'Email';
        emailConfig.Weight__c = 10;
        mockConfigs.add(emailConfig);

        ACME_Scoring_Configuration__mdt phoneConfig = new ACME_Scoring_Configuration__mdt();
        phoneConfig.MasterLabel = 'Phone';
        phoneConfig.Weight__c = 5;
        mockConfigs.add(phoneConfig);

        // Use Test.setMock to mock the metadata query
        Test.startTest();
        
        // Temporarily replace the getScoringConfigurations method with our mock data
        ACMELeadScoringService.getScoringConfigurations = () -> mockConfigs;
        
        Decimal score = ACMELeadScoringService.calculateLeadScore(testLead);
        
        Test.stopTest();

        // Assert the expected score
        System.assertEquals(15, score, 'Lead score calculation is incorrect');
    }
}