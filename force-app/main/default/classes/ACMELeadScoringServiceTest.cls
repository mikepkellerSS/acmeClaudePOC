/**
 * @description Test class for ACMELeadScoringService
 * @author ACME Development Team
 * @date 2024-02-15
 */
@isTest
private class ACMELeadScoringServiceTest {
    
    /**
     * Setup test data for lead scoring tests
     */
    @testSetup
    static void setupTestData() {
        List<Lead> testLeads = new List<Lead>();
        
        // High engagement lead
        testLeads.add(new Lead(
            FirstName = 'High',
            LastName = 'Engagement',
            Company = 'ACME Tech',
            Email_Opens__c = 10,
            Website_Visits__c = 20,
            Content_Downloads__c = 5,
            Industry = 'Technology',
            Number_of_Employees__c = 500,
            Title = 'Director of Operations'
        ));
        
        // Low engagement lead
        testLeads.add(new Lead(
            FirstName = 'Low',
            LastName = 'Engagement',
            Company = 'Small Business',
            Email_Opens__c = 1,
            Website_Visits__c = 2,
            Content_Downloads__c = 0,
            Industry = 'Retail',
            Number_of_Employees__c = 10,
            Title = 'Assistant'
        ));
        
        insert testLeads;
    }
    
    /**
     * Test lead scoring calculation for high engagement lead
     */
    @isTest
    static void testHighEngagementLeadScoring() {
        Lead highEngagementLead = [
            SELECT Id, Email_Opens__c, Website_Visits__c, 
                   Content_Downloads__c, Industry, 
                   Number_of_Employees__c, Title
            FROM Lead 
            WHERE FirstName = 'High' AND LastName = 'Engagement'
        ];
        
        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(highEngagementLead);
        Test.stopTest();
        
        System.assert(score > 70, 'High engagement lead should have a high score');
    }
    
    /**
     * Test lead scoring calculation for low engagement lead
     */
    @isTest
    static void testLowEngagementLeadScoring() {
        Lead lowEngagementLead = [
            SELECT Id, Email_Opens__c, Website_Visits__c, 
                   Content_Downloads__c, Industry, 
                   Number_of_Employees__c, Title
            FROM Lead 
            WHERE FirstName = 'Low' AND LastName = 'Engagement'
        ];
        
        Test.startTest();
        Decimal score = ACMELeadScoringService.calculateLeadScore(lowEngagementLead);
        Test.stopTest();
        
        System.assert(score < 30, 'Low engagement lead should have a low score');
    }
    
    /**
     * Test lead score update functionality
     */
    @isTest
    static void testLeadScoreUpdate() {
        Lead testLead = [
            SELECT Id 
            FROM Lead 
            WHERE FirstName = 'High' AND LastName = 'Engagement'
        ];
        
        Test.startTest();
        ACMELeadScoringService.updateLeadScore(testLead.Id);
        Test.stopTest();
        
        Lead updatedLead = [
            SELECT ACME_Lead_Score__c, ACME_Last_Scoring_Date__c 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];
        
        System.assertNotEquals(null, updatedLead.ACME_Lead_Score__c, 'Lead score should be updated');
        System.assertNotEquals(null, updatedLead.ACME_Last_Scoring_Date__c, 'Scoring date should be set');
    }
}