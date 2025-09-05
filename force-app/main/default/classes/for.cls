/**
 * Test class for ACME_LeadScoringService
 * Covers lead scoring calculation scenarios
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Test lead scoring for technology industry
     */
    @isTest
    static void testTechnologyIndustryScoring() {
        Lead testLead = new Lead(
            FirstName = 'Tech',
            LastName = 'Lead',
            Industry = 'Technology',
            NumberOfEmployees = 500,
            Website_Visits__c = 10,
            Email_Opens__c = 5
        );
        
        Decimal score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        System.assert(score > 50, 'Technology lead should have high score');
    }
    
    /**
     * Test lead scoring for small company
     */
    @isTest
    static void testSmallCompanyScoring() {
        Lead testLead = new Lead(
            FirstName = 'Small',
            LastName = 'Business',
            Industry = 'Retail',
            NumberOfEmployees = 50,
            Website_Visits__c = 3,
            Email_Opens__c = 2
        );
        
        Decimal score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        System.assert(score < 50, 'Small company should have lower score');
    }
    
    /**
     * Test score update functionality
     */
    @isTest
    static void testLeadScoreUpdate() {
        Lead testLead = new Lead(
            FirstName = 'Update',
            LastName = 'Test',
            Company = 'Test Company'
        );
        insert testLead;
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScore(testLead.Id, 75);
        Test.stopTest();
        
        Lead updatedLead = [SELECT ACME_Lead_Score__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(75, updatedLead.ACME_Lead_Score__c, 'Lead score should be updated');
    }
}