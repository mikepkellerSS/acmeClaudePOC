/**
 * Test class for Lead Scoring Service
 * @author Acme Corp Development Team
 * @date 2024
 */
@isTest
private class ACME_LeadScoringServiceTest {
    @TestSetup
    static void setupTestData() {
        List<Lead> testLeads = new List<Lead>();
        
        // Senior Tech Manager
        testLeads.add(new Lead(
            FirstName = 'Tech', 
            LastName = 'Manager', 
            Title = 'Senior Technology Manager',
            Company = 'TechCorp',
            Industry = 'Technology',
            NumberOfEmployees = 750,
            ACME__Whitepaper_Downloaded__c = true,
            ACME__Webinar_Attended__c = true,
            ACME__Pricing_Page_Visited__c = true,
            ACME__Demo_Requested__c = true
        ));

        // Junior Lead
        testLeads.add(new Lead(
            FirstName = 'Junior', 
            LastName = 'Associate', 
            Title = 'Associate',
            Company = 'SmallCo',
            Industry = 'Retail',
            NumberOfEmployees = 50
        ));

        insert testLeads;
    }

    @isTest
    static void testLeadScoringFullyEngaged() {
        Lead techManagerLead = [SELECT Id, ACME__Lead_Score__c FROM Lead WHERE Title = 'Senior Technology Manager' LIMIT 1];
        
        Test.startTest();
        List<Lead> scoredLeads = ACME_LeadScoringService.calculateLeadScores(new List<Lead>{techManagerLead});
        Test.stopTest();

        System.assertEquals(100, scoredLeads[0].ACME__Lead_Score__c, 'Lead should have maximum score');
        System.assertEquals(40, scoredLeads[0].ACME__Demographic_Score__c, 'Demographic score incorrect');
        System.assertEquals(60, scoredLeads[0].ACME__Engagement_Score__c, 'Engagement score incorrect');
    }

    @isTest
    static void testLeadScoringNoEngagement() {
        Lead juniorLead = [SELECT Id, ACME__Lead_Score__c FROM Lead WHERE Title = 'Associate' LIMIT 1];
        
        Test.startTest();
        List<Lead> scoredLeads = ACME_LeadScoringService.calculateLeadScores(new List<Lead>{juniorLead});
        Test.stopTest();

        System.assertEquals(0, scoredLeads[0].ACME__Lead_Score__c, 'Lead should have zero score');
        System.assertEquals(0, scoredLeads[0].ACME__Demographic_Score__c, 'Demographic score incorrect');
        System.assertEquals(0, scoredLeads[0].ACME__Engagement_Score__c, 'Engagement score incorrect');
    }
}