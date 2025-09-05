/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2025-09-05
 */
@isTest
private class ACME_LeadScoring_Service_Test {
    
    @testSetup
    static void setupTestData() {
        // Create test scoring models
        List<ACME_LeadScoreModel__c> models = new List<ACME_LeadScoreModel__c>{
            new ACME_LeadScoreModel__c(
                Metric_Name__c = 'Company Size', 
                Weight__c = 50, 
                Active__c = true
            ),
            new ACME_LeadScoreModel__c(
                Metric_Name__c = 'Industry', 
                Weight__c = 50, 
                Active__c = true
            )
        };
        insert models;
    }

    @isTest
    static void testLeadScoring_HighValueLead() {
        // Create a high-value lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            NumberOfEmployees = 1500,
            Industry = 'Technology'
        );

        Test.startTest();
        Integer score = ACME_LeadScoring_Service.calculateLeadScore(testLead);
        Test.stopTest();

        System.assertEquals(100, score, 'High-value lead should receive maximum score');
    }

    @isTest
    static void testLeadScoring_LowValueLead() {
        // Create a low-value lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Small Business',
            NumberOfEmployees = 5,
            Industry = 'Retail'
        );

        Test.startTest();
        Integer score = ACME_LeadScoring_Service.calculateLeadScore(testLead);
        Test.stopTest();

        System.assertEquals(0, score, 'Low-value lead should receive minimum score');
    }

    @isTest
    static void testLeadScoring_NullLead() {
        Test.startTest();
        Integer score = ACME_LeadScoring_Service.calculateLeadScore(null);
        Test.stopTest();

        System.assertEquals(0, score, 'Null lead should return zero score');
    }
}