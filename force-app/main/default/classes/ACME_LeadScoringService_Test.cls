/**
 * Test class for ACME_LeadScoringService
 * @author ACME Development Team
 * @date 2024-02-15
 * @description Unit tests for lead scoring service
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Test scenario for lead with complete information
     */
    @isTest
    static void testFullLeadScoreCalculation() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            Title = 'Director',
            Industry = 'Technology',
            NumberOfEmployees = 500,
            HasOptedOutOfEmail = false
        );
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(leadScore > 0 && leadScore <= 100, 
            'Lead score should be between 0 and 100');
    }
    
    /**
     * Test scenario for lead with minimal information
     */
    @isTest
    static void testMinimalLeadScoreCalculation() {
        Lead testLead = new Lead(
            FirstName = 'Minimal',
            LastName = 'Lead'
        );
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assertEquals(0, leadScore, 
            'Minimal lead should have zero score');
    }
    
    /**
     * Test bulk score update functionality
     */
    @isTest
    static void testBulkLeadScoreUpdate() {
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 10; i++) {
            testLeads.add(new Lead(
                FirstName = 'Bulk',
                LastName = 'Lead ' + i,
                Company = 'Test Company',
                Email = 'bulk' + i + '@test.com'
            ));
        }
        
        insert testLeads;
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();
        
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];
        
        System.assertEquals(10, updatedLeads.size(), 
            'All leads should be processed');
        
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 
                'Lead score should be calculated');
        }
    }
}