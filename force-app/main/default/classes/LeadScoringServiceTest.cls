/**
 * @description Test class for LeadScoringService
 * @author Acme Corp Development Team
 * @date 2024-02-15
 */
@isTest
private class LeadScoringServiceTest {
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
            Downloaded_Whitepaper__c = true,
            Attended_Webinar__c = true,
            Visited_Pricing_Page__c = true,
            Requested_Demo__c = true
        ));

        // Low Score Lead
        testLeads.add(new Lead(
            FirstName = 'Low Score',
            LastName = 'Prospect',
            Title = 'Intern',
            Company = 'Small Startup',
            NumberOfEmployees = 10,
            Industry = 'Retail',
            Downloaded_Whitepaper__c = false,
            Attended_Webinar__c = false,
            Visited_Pricing_Page__c = false,
            Requested_Demo__c = false
        ));

        insert testLeads;
    }

    @isTest
    static void testLeadScoringCalculation() {
        List<Lead> leads = [SELECT Id, Title, NumberOfEmployees, Industry, 
                            Downloaded_Whitepaper__c, Attended_Webinar__c, 
                            Visited_Pricing_Page__c, Requested_Demo__c,
                            Lead_Score__c, Demographic_Score__c, Engagement_Score__c
                            FROM Lead];

        Test.startTest();
        LeadScoringService.calculateLeadScores(leads);
        Test.stopTest();

        // Verify high score lead
        Lead highScoreLead = leads[0];
        System.assertEquals(40, highScoreLead.Demographic_Score__c, 'High score lead should have max demographic score');
        System.assertEquals(60, highScoreLead.Engagement_Score__c, 'High score lead should have max engagement score');
        System.assertEquals(100, highScoreLead.Lead_Score__c, 'High score lead should have maximum total score');

        // Verify low score lead
        Lead lowScoreLead = leads[1];
        System.assertEquals(0, lowScoreLead.Demographic_Score__c, 'Low score lead should have zero demographic score');
        System.assertEquals(0, lowScoreLead.Engagement_Score__c, 'Low score lead should have zero engagement score');
        System.assertEquals(0, lowScoreLead.Lead_Score__c, 'Low score lead should have zero total score');
    }

    @isTest
    static void testNullLeadHandling() {
        Test.startTest();
        LeadScoringService.calculateLeadScores(null);
        LeadScoringService.calculateLeadScores(new List<Lead>());
        Test.stopTest();

        // No exception should be thrown
        System.assert(true, 'Null and empty list handling should not throw exceptions');
    }

    @isTest
    static void testLeadScoringHistory() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company'
        );
        insert testLead;

        Test.startTest();
        LeadScoringService.createLeadScoringHistory(testLead.Id, 0, 50);
        Test.stopTest();

        List<LeadScoringHistory__c> histories = [SELECT Id, Lead__c, Previous_Score__c, New_Score__c 
                                                FROM LeadScoringHistory__c 
                                                WHERE Lead__c = :testLead.Id];
        
        System.assertEquals(1, histories.size(), 'One history record should be created');
        System.assertEquals(0, histories[0].Previous_Score__c, 'Previous score should be 0');
        System.assertEquals(50, histories[0].New_Score__c, 'New score should be 50');
    }

    @isTest
    static void testDemographicScoring() {
        Lead managerLead = new Lead(
            FirstName = 'Manager',
            LastName = 'Test',
            Title = 'Sales Manager',
            Company = 'Big Corp',
            NumberOfEmployees = 1000,
            Industry = 'Technology'
        );

        Test.startTest();
        LeadScoringService.calculateLeadScores(new List<Lead>{managerLead});
        Test.stopTest();

        System.assertEquals(40, managerLead.Demographic_Score__c, 'Manager at large tech company should get max demographic score');
    }

    @isTest
    static void testEngagementScoring() {
        Lead engagedLead = new Lead(
            FirstName = 'Engaged',
            LastName = 'Test',
            Company = 'Test Corp',
            Downloaded_Whitepaper__c = true,
            Attended_Webinar__c = true,
            Visited_Pricing_Page__c = true,
            Requested_Demo__c = true
        );

        Test.startTest();
        LeadScoringService.calculateLeadScores(new List<Lead>{engagedLead});
        Test.stopTest();

        System.assertEquals(60, engagedLead.Engagement_Score__c, 'Fully engaged lead should get max engagement score');
    }
}