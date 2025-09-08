/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2025-09-08
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    @isTest
    static void testCalculateLeadScore_FullyPopulatedLead() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Industry = 'Technology',
            NumberOfEmployees = 500,
            Email = 'test@microsoft.com',
            LeadSource = 'Web'
        );
        
        // Calculate score
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        // Assert expected score
        System.assert(score > 0, 'Lead score should be positive');
        System.assert(score <= 100, 'Lead score should not exceed 100');
    }
    
    @isTest
    static void testCalculateLeadScore_EmptyLead() {
        // Test with null lead
        Integer score = ACME_LeadScoringService.calculateLeadScore(null);
        
        // Assert zero score
        System.assertEquals(0, score, 'Null lead should return zero score');
    }
    
    @isTest
    static void testUpdateLeadScores() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(FirstName = 'Test1', LastName = 'Lead1', Company = 'Company1', Industry = 'Finance'),
            new Lead(FirstName = 'Test2', LastName = 'Lead2', Company = 'Company2', Industry = 'Technology')
        };
        
        // Test update method
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();
        
        // Verify scores were calculated
        for (Lead lead : testLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be calculated');
        }
    }
}