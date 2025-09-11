/**
 * @description Test class for Lead Scoring Service
 * @author Acme Corp Development Team
 * @date 2024
 */
@isTest
private class ACME_LeadScoringServiceTest {
    @TestSetup
    static void setupTestData() {
        List<Lead> testLeads = new List<Lead>();
        
        // High Score Lead
        testLeads.add(new Lead(
            FirstName = 'High Score',
            LastName = 'Lead',
            Title = 'VP of Sales',
            Company = 'Tech Giant Inc',
            NumberOfEmployees = 1000,
            Industry = 'Technology',
            ACME__Downloaded_Whitepaper__c = true,
            ACME__Attended_Webinar__c = true,
            ACME__Visited_Pricing_Page__c = true,
            ACME__Requested_Demo__c = true
        ));

        // Low Score Lead
        testLeads.add(new Lead(
            FirstName = 'Low Score',
            LastName = 'Lead',
            Title = 'Intern',
            Company = 'Small Startup',
            NumberOfEmployees = 10,
            Industry = 'Retail'
        ));

        insert testLeads;
    }

    @isTest
    static void testLeadScoringCalculation() {
        List<Lead> leads = [SELECT Id, Title, NumberOfEmployees, Industry, 
                            ACME__Downloaded_Whitepaper__c, ACME__Attended_Webinar__c, 
                            ACME__Visited_Pricing_Page__c, ACME__Requested_Demo__c 
                            FROM Lead];
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(leads);
        Test.stopTest();

        leads = [SELECT ACME__Lead_Score__c, ACME__Demographic_Score__c, ACME__Engagement_Score__c FROM Lead];
        
        // High Score Lead Assertions
        System.assertEquals(100, leads[0].ACME__Lead_Score__c, 'High score lead should have max score');
        System.assertEquals(40, leads[0].ACME__Demographic_Score__c, 'Demographic score should be 40');
        System.assertEquals(60, leads[0].ACME__Engagement_Score__c, 'Engagement score should be 60');

        // Low Score Lead Assertions
        System.assertEquals(0, leads[1].ACME__Lead_Score__c, 'Low score lead should have 0 score');
        System.assertEquals(0, leads[1].ACME__Demographic_Score__c, 'Demographic score should be 0');
        System.assertEquals(0, leads[1].ACME__Engagement_Score__c, 'Engagement score should be 0');
    }

    @isTest
    static void testLeadScoringHistoryCreation() {
        List<Lead> leads = [SELECT Id FROM Lead WHERE FirstName = 'High Score Lead'];
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(leads);
        Test.stopTest();

        List<ACME_LeadScoringHistory__c> histories = [SELECT ACME__Previous_Score__c, ACME__New_Score__c FROM ACME_LeadScoringHistory__c];
        
        System.assertEquals(1, histories.size(), 'One history record should be created');
        System.assertEquals(100, histories[0].ACME__New_Score__c, 'New score should be 100');
    }
}