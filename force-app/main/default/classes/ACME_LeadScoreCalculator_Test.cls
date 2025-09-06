/**
 * Test class for ACME_LeadScoreCalculator
 */
@isTest
private class ACME_LeadScoreCalculator_Test {
    
    /**
     * Test lead score calculation with various scenarios
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Industry = 'Technology',
            NumberOfEmployees = 500,
            HasOptedOutOfEmail = false
        );
        
        // Create test custom metadata
        ACME_LeadScoringRule__mdt industryRule = new ACME_LeadScoringRule__mdt(
            Metric__c = 'INDUSTRY',
            Weight__c = 25,
            Threshold__c = 'Technology'
        );
        
        // Test score calculation
        Test.startTest();
        Integer leadScore = ACME_LeadScoreCalculator.calculateLeadScore(testLead);
        Test.stopTest();
        
        // Assertions
        System.assert(leadScore > 0, 'Lead score should be positive');
        System.assert(leadScore <= 100, 'Lead score should not exceed 100');
    }
    
    /**
     * Test null lead handling
     */
    @isTest
    static void testNullLeadHandling() {
        Test.startTest();
        Integer leadScore = ACME_LeadScoreCalculator.calculateLeadScore(null);
        Test.stopTest();
        
        System.assertEquals(0, leadScore, 'Null lead should return zero score');
    }
}