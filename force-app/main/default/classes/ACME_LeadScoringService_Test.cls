/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2024-03-15
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Setup test data for lead scoring tests
     */
    @testSetup
    static void setupTestData() {
        // Create test scoring metrics
        List<ACME_Lead_Scoring_Metric__c> metrics = new List<ACME_Lead_Scoring_Metric__c>{
            new ACME_Lead_Scoring_Metric__c(
                Name = 'Email Engagement',
                Weight__c = 50,
                Criteria_Type__c = 'Engagement',
                Min_Value__c = 0,
                Max_Value__c = 10
            ),
            new ACME_Lead_Scoring_Metric__c(
                Name = 'Job Title',
                Weight__c = 50,
                Criteria_Type__c = 'Demographics',
                Min_Value__c = 0,
                Max_Value__c = 1
            )
        };
        insert metrics;
        
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            NumberOfEmailInteractions__c = 5,
            Title = 'Manager'
        );
        insert testLead;
    }
    
    /**
     * Test lead score calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        Lead testLead = [SELECT Id, NumberOfEmailInteractions__c, Title FROM Lead LIMIT 1];
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(leadScore >= 0 && leadScore <= 100, 'Lead score should be between 0-100');
    }
    
    /**
     * Test batch lead scoring process
     */
    @isTest
    static void testLeadScoringBatch() {
        Test.startTest();
        ACME_LeadScoringBatch batchJob = new ACME_LeadScoringBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        Lead updatedLead = [SELECT ACME_Lead_Score__c FROM Lead LIMIT 1];
        System.assertNotEquals(null, updatedLead.ACME_Lead_Score__c, 'Lead score should be calculated');
    }
}