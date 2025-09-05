@isTest
private class ACME_LeadScoringService_Test {
    @testSetup
    static void setupTestData() {
        // Create test leads and scoring criteria
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Company = 'ACME Corp',
                Industry = 'Technology'
            )
        };
        insert testLeads;
    }

    @isTest
    static void testLeadScoring() {
        // Retrieve test leads
        List<Lead> leads = [SELECT Id, FirstName, LastName, Industry 
                            FROM Lead 
                            WHERE LastName = 'Lead1'];
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(leads);
        Test.stopTest();

        // Verify scoring results
        leads = [SELECT ACME_Lead_Score__c, 
                        ACME_Engagement_Score__c, 
                        ACME_Demographic_Score__c 
                 FROM Lead 
                 WHERE Id IN :leads];
        
        System.assertNotEquals(null, leads[0].ACME_Lead_Score__c, 
            'Lead score should be calculated');
    }

    @isTest
    static void testEmptyLeadList() {
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(new List<Lead>());
        Test.stopTest();
        
        // No assertion needed, just ensuring no exception is thrown
    }
}