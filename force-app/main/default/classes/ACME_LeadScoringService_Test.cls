/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2025-09-06
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    @testSetup
    static void setupTestData() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 10; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Status = 'Open - Not Contacted'
            ));
        }
        insert testLeads;
    }

    @isTest
    static void testLeadScoring() {
        // Retrieve test leads
        List<Lead> leads = [SELECT Id, Company, ACME_Last_Engagement_Date__c 
                            FROM Lead 
                            WHERE LastName LIKE 'Test Lead%'];
        
        // Set up some test engagement dates
        leads[0].ACME_Last_Engagement_Date__c = System.today().addDays(-15);
        leads[1].ACME_Last_Engagement_Date__c = System.today().addDays(-45);
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(leads);
        Test.stopTest();

        // Verify scores are calculated
        for (Lead lead : leads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 
                'Lead score should be calculated');
            System.assert(lead.ACME_Lead_Score__c >= 0 && lead.ACME_Lead_Score__c <= 100, 
                'Lead score should be between 0 and 100');
        }
    }

    @isTest
    static void testEmptyLeadList() {
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(new List<Lead>());
        Test.stopTest();
        // Ensure no exception is thrown
        System.assert(true, 'Empty list should be handled gracefully');
    }
}