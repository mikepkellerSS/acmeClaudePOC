/**
 * @description Test class for ACME_LeadScoringService
 * @author Acme Corp Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringServiceTest {
    @TestSetup
    static void setupTestData() {
        List<Lead> testLeads = new List<Lead>();
        
        // High Score Lead
        testLeads.add(new Lead(
            FirstName = 'High Score',
            LastName = 'Prospect',
            Title = 'VP of Sales',
            Company = 'Large Tech Corp',
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
            LastName = 'Prospect',
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
        
        System.assertEquals(100, leads[0].ACME__Lead_Score__c, 'High score lead should have maximum score');
        System.assertEquals(0, leads[1].ACME__Lead_Score__c, 'Low score lead should have minimum score');

        List<ACME_LeadScoringHistory__c> histories = [SELECT Id FROM ACME_LeadScoringHistory__c];
        System.assertEquals(2, histories.size(), 'Scoring history should be created for each lead');
    }

    @isTest
    static void testNullLeadHandling() {
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(null);
        ACME_LeadScoringService.calculateLeadScores(new List<Lead>());
        Test.stopTest();

        // No exception should be thrown
        System.assert(true, 'Null and empty list handling should not throw exceptions');
    }
}