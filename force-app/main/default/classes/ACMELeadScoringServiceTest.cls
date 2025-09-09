/**
 * Test class for ACMELeadScoringService
 */
@isTest
private class ACMELeadScoringServiceTest {
    
    /**
     * Setup test data for lead scoring tests
     */
    @testSetup
    static void setupTestData() {
        // Create test lead with sample scores
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            ACME_Engagement_Score__c = 75,
            ACME_Demographics_Score__c = 85
        );
        insert testLead;
    }
    
    /**
     * Test lead score calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Retrieve test lead
        Lead testLead = [
            SELECT Id, ACME_Engagement_Score__c, ACME_Demographics_Score__c 
            FROM Lead 
            WHERE LastName = 'Lead' 
            LIMIT 1
        ];
        
        Test.startTest();
        Decimal calculatedScore = ACMELeadScoringService.calculateLeadScore(testLead.Id);
        Test.stopTest();
        
        // Assert score is within expected range
        System.assert(calculatedScore >= 0 && calculatedScore <= 100, 
            'Lead score should be between 0 and 100');
    }
    
    /**
     * Test lead score update
     */
    @isTest
    static void testLeadScoreUpdate() {
        Lead testLead = [
            SELECT Id 
            FROM Lead 
            WHERE LastName = 'Lead' 
            LIMIT 1
        ];
        
        Test.startTest();
        ACMELeadScoringService.updateLeadScore(testLead.Id, 85);
        Test.stopTest();
        
        Lead updatedLead = [
            SELECT ACME_Lead_Score__c, ACME_Last_Scored_Timestamp__c 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];
        
        System.assertEquals(85, updatedLead.ACME_Lead_Score__c, 
            'Lead score should be updated correctly');
        System.assertNotEquals(null, updatedLead.ACME_Last_Scored_Timestamp__c, 
            'Timestamp should be set');
    }
}