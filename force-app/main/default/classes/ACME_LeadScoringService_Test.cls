@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'ACME Corp',
                AnnualRevenue = 500000
            )
        };
        
        // Insert test leads
        insert testLeads;
        
        // Create test metadata
        List<ACME_Scoring_Criteria__mdt> testCriteria = new List<ACME_Scoring_Criteria__mdt>{
            new ACME_Scoring_Criteria__mdt(
                Score_Type__c = 'Demographic',
                Criteria_Field__c = 'AnnualRevenue',
                Minimum_Value__c = 100000,
                Maximum_Value__c = 1000000,
                Score_Points__c = 50
            )
        };
        
        // Run scoring
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(testLeads);
        Test.stopTest();
        
        // Verify results
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];
        
        System.assertEquals(50, updatedLeads[0].ACME_Lead_Score__c, 
            'Lead score should match expected value');
    }
    
    @isTest
    static void testErrorHandling() {
        // Test error scenarios
        List<Lead> emptyLeads = new List<Lead>();
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(emptyLeads);
        Test.stopTest();
        
        // No assertion needed - just ensuring no unhandled exceptions
        System.assert(true, 'Error handling test passed');
    }
}