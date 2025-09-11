/**
 * @description Test class for Lead Scoring Service
 * @author Acme Corp
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
            Company = 'Large Tech Corp',
            NumberOfEmployees = 1000,
            Industry = 'Technology',
            ACME__Whitepaper_Downloaded__c = true,
            ACME__Webinar_Attended__c = true,
            ACME__Pricing_Page_Visited__c = true,
            ACME__Demo_Requested__c = true
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
    static void testLeadScoringService() {
        List<Lead> leads = [SELECT Id, Title, NumberOfEmployees, Industry, 
                            ACME__Whitepaper_Downloaded__c, ACME__Webinar_Attended__c, 
                            ACME__Pricing_Page_Visited__c, ACME__Demo_Requested__c 
                            FROM Lead];
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(leads);
        Test.stopTest();

        // Verify High Score Lead
        Lead highScoreLead = leads[0];
        System.assertEquals(40, highScoreLead.ACME__Demographic_Score__c, 'Demographic score incorrect');
        System.assertEquals(60, highScoreLead.ACME__Engagement_Score__c, 'Engagement score incorrect');
        System.assertEquals(100, highScoreLead.ACME__Lead_Score__c, 'Total lead score incorrect');

        // Verify Low Score Lead
        Lead lowScoreLead = leads[1];
        System.assertEquals(0, lowScoreLead.ACME__Demographic_Score__c, 'Low score demographic score incorrect');
        System.assertEquals(0, lowScoreLead.ACME__Engagement_Score__c, 'Low score engagement score incorrect');
        System.assertEquals(0, lowScoreLead.ACME__Lead_Score__c, 'Low score total lead score incorrect');

        // Verify Scoring History Records
        List<ACME_LeadScoringHistory__c> histories = [SELECT Id FROM ACME_LeadScoringHistory__c];
        System.assertEquals(2, histories.size(), 'Incorrect number of scoring history records');
    }
}