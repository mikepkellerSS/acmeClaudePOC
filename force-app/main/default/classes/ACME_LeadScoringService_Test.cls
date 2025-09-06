/**
 * @description Test class for Lead Scoring Service
 * @author Acme Corp Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    @testSetup
    static void setupTestData() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1',
                Company = 'Acme Corp',
                Email = 'test1@example.com',
                LeadSource = 'Web'
            ),
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead2',
                Company = 'Another Company',
                Email = 'test2@example.com',
                LeadSource = 'Referral'
            )
        };
        insert testLeads;
    }

    @isTest
    static void testLeadScoreCalculation() {
        // Retrieve test lead
        Lead testLead = [SELECT Id, FirstName, LastName, Company, Email, LeadSource 
                         FROM Lead 
                         WHERE LastName = 'Lead1' 
                         LIMIT 1];

        Test.startTest();
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert score is within valid range
        System.assert(calculatedScore >= 0 && calculatedScore <= 100, 
            'Lead score should be between 0 and 100');
    }

    @isTest
    static void testLeadScoreUpdate() {
        // Retrieve test lead
        Lead testLead = [SELECT Id FROM Lead WHERE LastName = 'Lead1' LIMIT 1];

        Test.startTest();
        ACME_LeadScoringService.updateLeadScore(testLead.Id, 75);
        Test.stopTest();

        // Verify lead was updated
        Lead updatedLead = [SELECT ACME_Lead_Score__c, ACME_Last_Scored_Date__c 
                             FROM Lead 
                             WHERE Id = :testLead.Id];
        
        System.assertEquals(75, updatedLead.ACME_Lead_Score__c, 
            'Lead score should be updated correctly');
        System.assertNotEquals(null, updatedLead.ACME_Last_Scored_Date__c, 
            'Last scored date should be set');
    }

    @isTest
    static void testErrorHandling() {
        Test.startTest();
        Integer score = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();

        // Verify default behavior for null input
        System.assertEquals(0, score, 'Null lead should return zero score');
    }
}