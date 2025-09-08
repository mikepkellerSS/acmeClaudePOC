/**
 * Test class for ACME_LeadScoringService
 * Ensures comprehensive test coverage for lead scoring logic
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Setup test data for lead scoring metrics
     */
    @testSetup
    static void setupTestData() {
        // Create test scoring metrics
        List<ACME_Lead_Scoring_Metric__c> metrics = new List<ACME_Lead_Scoring_Metric__c>{
            new ACME_Lead_Scoring_Metric__c(
                ACME_Criteria_Name__c = 'Email Engagement',
                ACME_Weight__c = 0.5,
                ACME_Criteria_Type__c = 'Engagement'
            ),
            new ACME_Lead_Scoring_Metric__c(
                ACME_Criteria_Name__c = 'Company Size',
                ACME_Weight__c = 0.5,
                ACME_Criteria_Type__c = 'Demographics'
            )
        };
        insert metrics;
    }

    /**
     * Test lead score calculation with complete lead information
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            NumberOfEmployees = 100,
            Country = 'United States',
            Title = 'Director'
        );

        Test.startTest();
        Decimal calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert score is within expected range
        System.assert(calculatedScore >= 1 && calculatedScore <= 100, 
            'Lead score should be between 1 and 100');
    }

    /**
     * Test lead score calculation with minimal information
     */
    @isTest
    static void testLeadScoreWithMinimalData() {
        // Create test lead with minimal information
        Lead testLead = new Lead(
            FirstName = 'Minimal',
            LastName = 'Lead',
            Company = 'Small Company'
        );

        Test.startTest();
        Decimal calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert low score for minimal data
        System.assert(calculatedScore < 50, 'Lead score should be low with minimal data');
    }

    /**
     * Test bulk lead score update
     */
    @isTest
    static void testBulkLeadScoreUpdate() {
        // Create multiple test leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Bulk',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Email = 'bulk' + i + '@example.com'
            ));
        }
        insert testLeads;

        Test.startTest();
        ACME_LeadScoringService.updateLeadScoreOnChange(testLeads);
        Test.stopTest();

        // Retrieve updated leads and verify scores
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];

        System.assertEquals(200, updatedLeads.size(), 'All leads should be processed');
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 
                'Lead score should be calculated');
        }
    }
}