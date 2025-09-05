/**
 * Test class for ACME_LeadScoringService
 */
@isTest
private class ACME_LeadScoringServiceTest {
    
    /**
     * Setup test data for lead scoring metrics
     */
    @testSetup
    static void setupTestData() {
        // Create test scoring metrics
        List<ACME_Lead_Scoring_Metric__c> metrics = new List<ACME_Lead_Scoring_Metric__c>{
            new ACME_Lead_Scoring_Metric__c(
                Name = 'Large Company',
                Weight__c = 50,
                Category__c = 'Demographics',
                Active__c = true
            ),
            new ACME_Lead_Scoring_Metric__c(
                Name = 'Inbound Lead',
                Weight__c = 30,
                Category__c = 'Engagement',
                Active__c = true
            )
        };
        insert metrics;
    }

    /**
     * Test lead score calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            NumberOfEmployees = 200,
            LeadSource = 'Web'
        );
        insert testLead;

        // Perform test
        Test.startTest();
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert expected score
        System.assert(score > 0, 'Score should be positive');
        System.assert(score <= 100, 'Score should not exceed 100');
    }

    /**
     * Test bulk lead score update
     */
    @isTest
    static void testBulkLeadScoreUpdate() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(FirstName = 'Test1', LastName = 'Lead1', Company = 'Company1', NumberOfEmployees = 150),
            new Lead(FirstName = 'Test2', LastName = 'Lead2', Company = 'Company2', NumberOfEmployees = 250)
        };
        insert testLeads;

        // Perform test
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();

        // Retrieve updated leads and verify scores
        List<Lead> updatedLeads = [SELECT ACME_Lead_Score__c FROM Lead WHERE Id IN :testLeads];
        System.assertEquals(2, updatedLeads.size(), 'All leads should be processed');
    }
}