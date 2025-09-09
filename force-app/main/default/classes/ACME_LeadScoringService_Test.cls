/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2025-09-09
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Test lead score calculation with various scenarios
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Test scenario 1: Small company
        Lead smallCompanyLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Small Tech',
            NumberOfEmployees = 5,
            LeadSource = 'Web',
            Industry = 'Technology',
            Title = 'Manager'
        );
        
        Integer score = ACME_LeadScoringService.calculateLeadScore(smallCompanyLead);
        System.assert(score > 0 && score <= 100, 'Score should be between 0 and 100');

        // Test scenario 2: Large company
        Lead largeCompanyLead = new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Company = 'Large Corp',
            NumberOfEmployees = 500,
            LeadSource = 'Campaign',
            Industry = 'Finance',
            Title = 'Director'
        );
        
        score = ACME_LeadScoringService.calculateLeadScore(largeCompanyLead);
        System.assert(score > 0 && score <= 100, 'Score should be between 0 and 100');
    }

    /**
     * Test bulk lead score update
     */
    @isTest
    static void testBulkLeadScoreUpdate() {
        List<Lead> testLeads = new List<Lead>();
        
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                NumberOfEmployees = 50 + i,
                LeadSource = 'Web'
            ));
        }

        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();

        for (Lead lead : testLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be calculated');
            System.assertNotEquals(null, lead.ACME_Last_Score_Calculation__c, 'Score calculation timestamp should be set');
        }
    }
}