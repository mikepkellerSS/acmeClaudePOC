/**
 * Test class for ACME_LeadScoringService to ensure comprehensive code coverage
 */
@isTest
private class ACME_LeadScoringServiceTest {
    
    /**
     * Test lead score calculation with valid lead
     */
    @isTest
    static void testCalculateLeadScore() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Title = 'Director',
            NumberOfEmployees = 250
        );
        
        // Calculate score
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        // Assertions
        System.assertNotEquals(null, score, 'Score should not be null');
        System.assert(score >= 0 && score <= 100, 'Score should be between 0 and 100');
    }

    /**
     * Test lead score update functionality
     */
    @isTest
    static void testUpdateLeadScore() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Update',
            LastName = 'Score',
            Company = 'Test Inc',
            Status = 'Open'
        );
        insert testLead;

        // Calculate and update score
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        ACME_LeadScoringService.updateLeadScore(testLead.Id, score);

        // Retrieve updated lead
        Lead updatedLead = [
            SELECT ACME_LeadScore__c, ACME_EngagementLevel__c 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];

        // Assertions
        System.assertEquals(score, updatedLead.ACME_LeadScore__c, 'Lead score should match calculated score');
        System.assertNotEquals(null, updatedLead.ACME_EngagementLevel__c, 'Engagement level should be set');
    }

    /**
     * Test null lead scenario
     */
    @isTest
    static void testNullLeadScore() {
        Integer score = ACME_LeadScoringService.calculateLeadScore(null);
        System.assertEquals(0, score, 'Null lead should return zero score');
    }
}