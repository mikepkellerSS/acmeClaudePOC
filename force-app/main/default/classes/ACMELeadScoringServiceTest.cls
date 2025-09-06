@isTest
private class ACMELeadScoringServiceTest {
    @TestSetup
    static void setupTestData() {
        // Create test metadata records
        List<ACME_Scoring_Configuration__mdt> testConfigs = new List<ACME_Scoring_Configuration__mdt>();
        
        // Mock metadata for testing
        ACME_Scoring_Configuration__mdt industryConfig = new ACME_Scoring_Configuration__mdt();
        industryConfig.MasterLabel = 'Industry';
        industryConfig.ACME_Weight__c = 0.5;
        testConfigs.add(industryConfig);
        
        ACME_Scoring_Configuration__mdt companyConfig = new ACME_Scoring_Configuration__mdt();
        companyConfig.MasterLabel = 'Company Size';
        companyConfig.ACME_Weight__c = 0.3;
        testConfigs.add(companyConfig);
    }
    
    @isTest
    static void testLeadScoring() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Industry = 'Technology'
        );
        
        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assertNotEquals(null, score, 'Score should be calculated');
        System.assert(score > 0, 'Score should be positive');
    }
    
    @isTest
    static void testIndustryScoring() {
        Lead techLead = new Lead(
            FirstName = 'Tech',
            LastName = 'Lead',
            Company = 'Tech Company',
            Industry = 'Technology'
        );
        
        Lead financeLead = new Lead(
            FirstName = 'Finance',
            LastName = 'Lead',
            Company = 'Finance Corp',
            Industry = 'Finance'
        );
        
        Test.startTest();
        Decimal techScore = ACMELeadScoringService.calculateLeadScore(techLead);
        Decimal financeScore = ACMELeadScoringService.calculateLeadScore(financeLead);
        Test.stopTest();
        
        System.assert(techScore > financeScore, 'Technology industry should have higher score');
    }
}