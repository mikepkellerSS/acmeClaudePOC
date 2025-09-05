/**
 * Test class for Lead Scoring Service
 * @author ACME Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringServiceTest {
    @isTest
    static void testLeadScoreCalculation() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1',
                Company = 'ACME Corp',
                NumberOfEmployees = 250,
                Industry = 'Technology',
                Title = 'Director of Operations',
                HasOptedOutOfEmail = false,
                Website = 'www.testcompany.com'
            )
        };

        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(testLeads);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, testLeads[0].ACME_Lead_Score__c, 
            'Lead score should be calculated');
        System.assert(testLeads[0].ACME_Lead_Score__c >= 0 && 
                      testLeads[0].ACME_Lead_Score__c <= 100, 
            'Lead score should be within valid range');
    }

    @isTest
    static void testEmptyLeadList() {
        List<Lead> emptyLeads = new List<Lead>();

        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(emptyLeads);
        Test.stopTest();

        // No exception should be thrown
        System.assertEquals(0, emptyLeads.size(), 'Empty list should remain empty');
    }
}