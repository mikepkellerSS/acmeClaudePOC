/**
 * Test class for ACME_LeadScoringService
 */
@isTest
private class ACME_LeadScoringServiceTest {
    
    /**
     * Test lead score calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Title = 'Director of Sales',
            NumberOfEmployees = 500
        );
        insert testLead;
        
        // Execute score calculation
        Test.startTest();
        Decimal score = ACME_LeadScoringService.calculateLeadScore(testLead.Id);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(0, score, 'Score should be calculated');
        
        // Verify lead score record
        ACME_LeadScore__c leadScore = [
            SELECT Score__c, EngagementPoints__c, DemographicPoints__c 
            FROM ACME_LeadScore__c 
            WHERE Lead__c = :testLead.Id 
            LIMIT 1
        ];
        
        System.assertEquals(score, leadScore.Score__c, 'Score should match');
        System.assertNotEquals(0, leadScore.EngagementPoints__c, 'Engagement points should be calculated');
        System.assertNotEquals(0, leadScore.DemographicPoints__c, 'Demographic points should be calculated');
    }
    
    /**
     * Test null lead ID handling
     */
    @isTest
    static void testNullLeadIdHandling() {
        // Verify exception is thrown for null lead ID
        try {
            ACME_LeadScoringService.calculateLeadScore(null);
            System.assert(false, 'Expected IllegalArgumentException');
        } catch (IllegalArgumentException e) {
            System.assert(true, 'Correct exception thrown');
        }
    }
}