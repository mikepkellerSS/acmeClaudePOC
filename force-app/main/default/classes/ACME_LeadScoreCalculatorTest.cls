/**
 * @description Unit tests for lead score calculation
 * @author Salesforce Architect
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoreCalculatorTest {
    @TestSetup
    static void setupTestData() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>();
        
        // High Score Lead
        testLeads.add(new Lead(
            FirstName = 'High Score',
            LastName = 'Lead',
            Company = 'Enterprise Tech',
            NumberOfEmployees = 600,
            Industry = 'Technology',
            ACME__Web_Visits__c = 25,
            ACME__Campaign_Responses__c = 5,
            HasOptedOutOfEmail = false
        ));

        // Low Score Lead
        testLeads.add(new Lead(
            FirstName = 'Low Score',
            LastName = 'Lead',
            Company = 'Small Business',
            NumberOfEmployees = 10,
            Industry = 'Retail',
            ACME__Web_Visits__c = 2,
            ACME__Campaign_Responses__c = 0,
            HasOptedOutOfEmail = true
        ));

        insert testLeads;
    }

    @isTest
    static void testHighScoreLead() {
        Lead highScoreLead = [SELECT 
            FirstName, LastName, NumberOfEmployees, Industry, 
            ACME__Web_Visits__c, ACME__Campaign_Responses__c, HasOptedOutOfEmail 
            FROM Lead WHERE FirstName = 'High Score' LIMIT 1];

        Test.startTest();
        Integer leadScore = ACME_LeadScoreCalculator.calculateLeadScore(highScoreLead);
        Test.stopTest();

        System.assert(leadScore >= 80 && leadScore <= 100, 'High score lead should have high score');
    }

    @isTest
    static void testLowScoreLead() {
        Lead lowScoreLead = [SELECT 
            FirstName, LastName, NumberOfEmployees, Industry, 
            ACME__Web_Visits__c, ACME__Campaign_Responses__c, HasOptedOutOfEmail 
            FROM Lead WHERE FirstName = 'Low Score' LIMIT 1];

        Test.startTest();
        Integer leadScore = ACME_LeadScoreCalculator.calculateLeadScore(lowScoreLead);
        Test.stopTest();

        System.assert(leadScore >= 0 && leadScore <= 20, 'Low score lead should have low score');
    }
}