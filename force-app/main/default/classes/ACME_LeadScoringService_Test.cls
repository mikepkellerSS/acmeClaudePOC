@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'Test Company',
                Industry = 'Technology'
            )
        };
        insert testLeads;

        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(testLeads);
        Test.stopTest();

        // Retrieve updated leads
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c, ACME_Last_Score_Calculated__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];

        // Assertions
        System.assertNotEquals(null, updatedLeads[0].ACME_Lead_Score__c, 
            'Lead score should be calculated');
        System.assertNotEquals(null, updatedLeads[0].ACME_Last_Score_Calculated__c, 
            'Score calculation timestamp should be set');
        System.assert(updatedLeads[0].ACME_Lead_Score__c >= 0 && 
                      updatedLeads[0].ACME_Lead_Score__c <= 100, 
            'Lead score should be between 0 and 100');
    }

    @isTest
    static void testEmptyLeadList() {
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(new List<Lead>());
        Test.stopTest();
        
        // No assertion needed - just ensuring no exceptions
        System.assert(true, 'Empty list should not cause errors');
    }
}