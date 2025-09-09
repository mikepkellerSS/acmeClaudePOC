/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2024-03-15
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Test lead scoring for technology company with high engagement
     */
    @isTest
    static void testHighScoreLead() {
        // Create test lead with optimal scoring attributes
        Lead testLead = new Lead(
            FirstName = 'High',
            LastName = 'Potential',
            Company = 'Tech Innovators Inc',
            NumberOfEmployees = 600,
            Industry = 'Technology',
            ACME_Website_Visits__c = 12,
            ACME_Email_Interactions__c = 6,
            ACME_Content_Downloads__c = 4
        );
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        // Assert high score range
        System.assert(leadScore >= 80 && leadScore <= 100, 
            'High potential lead should have high score');
    }
    
    /**
     * Test lead scoring for low engagement lead
     */
    @isTest
    static void testLowScoreLead() {
        // Create test lead with minimal scoring attributes
        Lead testLead = new Lead(
            FirstName = 'Low',
            LastName = 'Potential',
            Company = 'Small Local Business',
            NumberOfEmployees = 10,
            Industry = 'Retail',
            ACME_Website_Visits__c = 1,
            ACME_Email_Interactions__c = 0,
            ACME_Content_Downloads__c = 0
        );
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        // Assert low score range
        System.assert(leadScore >= 0 && leadScore <= 20, 
            'Low potential lead should have low score');
    }
    
    /**
     * Test null lead handling
     */
    @isTest
    static void testNullLeadScoring() {
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();
        
        System.assertEquals(0, leadScore, 
            'Null lead should return zero score');
    }
}