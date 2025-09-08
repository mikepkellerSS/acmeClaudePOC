@isTest
private class ACMELeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        // Create test metadata
        List<ACME_Scoring_Configuration__mdt> mockConfigs = new List<ACME_Scoring_Configuration__mdt>();
        
        ACME_Scoring_Configuration__mdt emailConfig = new ACME_Scoring_Configuration__mdt();
        emailConfig.DeveloperName = 'Email_Config';
        emailConfig.Field_Name__c = 'Email';
        emailConfig.Score_Value__c = 10;
        mockConfigs.add(emailConfig);
        
        ACME_Scoring_Configuration__mdt phoneConfig = new ACME_Scoring_Configuration__mdt();
        phoneConfig.DeveloperName = 'Phone_Config';
        phoneConfig.Field_Name__c = 'Phone';
        phoneConfig.Score_Value__c = 5;
        mockConfigs.add(phoneConfig);
        
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Email = 'test@example.com',
            Phone = '1234567890'
        );
        
        Test.startTest();
        List<Lead> scoredLeads = ACMELeadScoringService.scoreLead(new List<Lead>{testLead});
        Test.stopTest();
        
        System.assertEquals(15, scoredLeads[0].Lead_Score__c, 'Lead score should be 15');
    }
}