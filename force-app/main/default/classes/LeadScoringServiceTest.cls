/**
 * @description Test class for Lead Scoring Service
 * @author Acme Corp Development Team
 * @date 2024
 */
@isTest
private class LeadScoringServiceTest {
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
            Downloaded_Whitepaper__c = true,
            Attended_Webinar__c = true,
            Visited_Pricing_Page__c = true,
            Requested_Demo__c = true
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
                            Downloaded_Whitepaper__c, Attended_Webinar__c, 
                            Visited_Pricing_Page__c, Requested_Demo__c 
                            FROM Lead];
        
        Test.startTest();
        LeadScoringService.calculateLeadScores(leads);
        Test.stopTest();

        leads = [SELECT Lead_Score__c, Demographic_Score__c, Engagement_Score__c FROM Lead ORDER BY FirstName];
        
        // High Score Lead Assertions
        System.assertEquals(100, leads[0].Lead_Score__c, 'High score lead should have max score');
        System.assertEquals(40, leads[0].Demographic_Score__c, 'Demographic score should be 40');
        System.assertEquals(60, leads[0].Engagement_Score__c, 'Engagement score should be 60');

        // Low Score Lead Assertions
        System.assertEquals(0, leads[1].Lead_Score__c, 'Low score lead should have 0 score');
        System.assertEquals(0, leads[1].Demographic_Score__c, 'Demographic score should be 0');
        System.assertEquals(0, leads[1].Engagement_Score__c, 'Engagement score should be 0');
    }

    @isTest
    static void testLeadScoringBulkOperation() {
        List<Lead> bulkLeads = new List<Lead>();
        
        for (Integer i = 0; i < 200; i++) {
            bulkLeads.add(new Lead(
                FirstName = 'Bulk',
                LastName = 'Lead' + i,
                Title = 'Manager',
                Company = 'Test Company ' + i,
                NumberOfEmployees = 600,
                Industry = 'Technology'
            ));
        }
        
        Test.startTest();
        insert bulkLeads;
        Test.stopTest();
        
        List<Lead> insertedLeads = [SELECT Lead_Score__c FROM Lead WHERE FirstName = 'Bulk'];
        System.assertEquals(200, insertedLeads.size(), 'All bulk leads should be inserted');
        
        for (Lead lead : insertedLeads) {
            System.assertEquals(40, lead.Lead_Score__c, 'Each bulk lead should have score of 40');
        }
    }

    @isTest
    static void testNullHandling() {
        Lead nullLead = new Lead(
            FirstName = 'Null',
            LastName = 'Lead',
            Company = 'Test Company'
        );
        
        Test.startTest();
        insert nullLead;
        Test.stopTest();
        
        Lead insertedLead = [SELECT Lead_Score__c, Demographic_Score__c, Engagement_Score__c FROM Lead WHERE FirstName = 'Null'];
        System.assertEquals(0, insertedLead.Lead_Score__c, 'Lead with null values should have 0 score');
    }
}