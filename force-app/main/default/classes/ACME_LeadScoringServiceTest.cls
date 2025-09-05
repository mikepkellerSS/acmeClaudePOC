@isTest
private class ACME_LeadScoringServiceTest {
    
    /**
     * @description Test lead scoring calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'ACME Corp',
                Title = 'Director',
                ACME_Engagement_Frequency__c = 3
            )
        };

        // Perform test
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(testLeads);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(0, testLeads[0].ACME_Lead_Score__c, 
            'Lead score should be calculated');
        System.assert(testLeads[0].ACME_Lead_Score__c <= 100, 
            'Lead score should not exceed 100');
    }

    /**
     * @description Test empty lead list handling
     */
    @isTest
    static void testEmptyLeadList() {
        // Perform test
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(new List<Lead>());
        Test.stopTest();

        // No assertion needed - just ensuring no exception
        System.assert(true, 'Empty list should be handled gracefully');
    }
}