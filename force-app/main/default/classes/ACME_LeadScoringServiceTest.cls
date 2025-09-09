/**
 * @description Test class for ACME_LeadScoringService
 * @author ACME Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringServiceTest {
    
    /**
     * Test lead score calculation with complete lead data
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            NumberOfEmployees = 250,
            Industry = 'Technology',
            Number_of_Website_Visits__c = 5,
            HasOptedOutOfEmail = false
        );
        
        // Calculate score
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        // Assert score is within expected range
        System.assert(score >= 0 && score <= 100, 'Score should be between 0-100');
        System.assertNotEquals(0, score, 'Score should not be zero for valid lead');
    }

    /**
     * Test lead score update functionality
     */
    @isTest
    static void testLeadScoreUpdate() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Update',
            LastName = 'Test',
            Company = 'Test Company',
            Email = 'update@test.com',
            NumberOfEmployees = 100,
            Industry = 'Finance'
        );
        insert testLead;

        // Update lead score
        Test.startTest();
        ACME_LeadScoringService.updateLeadScore(testLead.Id);
        Test.stopTest();

        // Retrieve updated lead
        Lead updatedLead = [
            SELECT ACME_Lead_Score__c, ACME_Last_Score_Calculation__c 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];

        // Assertions
        System.assertNotEquals(null, updatedLead.ACME_Lead_Score__c, 'Lead score should be calculated');
        System.assertNotEquals(null, updatedLead.ACME_Last_Score_Calculation__c, 'Calculation timestamp should be set');
    }

    /**
     * Test edge cases for lead score calculation
     */
    @isTest
    static void testEdgeCases() {
        // Test null lead
        Integer nullScore = ACME_LeadScoringService.calculateLeadScore(null);
        System.assertEquals(0, nullScore, 'Null lead should return zero score');
    }
}