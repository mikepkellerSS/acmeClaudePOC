/**
 * @description Test class for ACME_LeadScoringService
 * @author ACME Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Create test lead data
     * @return Lead test lead record
     */
    private static Lead createTestLead() {
        return new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            Number_of_Website_Visits__c = 5,
            Social_Media_Interactions__c = 3,
            Number_of_Employees__c = 250,
            Industry = 'Technology',
            Title = 'Director of Operations'
        );
    }

    /**
     * Test lead score calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        Lead testLead = createTestLead();
        
        Test.startTest();
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        // Assert score is within expected range
        System.assert(calculatedScore >= 0 && calculatedScore <= 100, 
            'Lead score should be between 0 and 100');
    }

    /**
     * Test null lead handling
     */
    @isTest
    static void testNullLeadHandling() {
        Test.startTest();
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();

        System.assertEquals(0, calculatedScore, 
            'Null lead should return zero score');
    }

    /**
     * Test lead score update
     */
    @isTest
    static void testLeadScoreUpdate() {
        Lead testLead = createTestLead();
        insert testLead;
        
        Test.startTest();
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        ACME_LeadScoringService.updateLeadScore(testLead.Id, calculatedScore);
        Test.stopTest();

        // Retrieve updated lead
        Lead updatedLead = [
            SELECT ACME_Lead_Score__c, ACME_Last_Score_Calculation__c 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];

        System.assertEquals(calculatedScore, updatedLead.ACME_Lead_Score__c, 
            'Lead score should be updated');
        System.assertNotEquals(null, updatedLead.ACME_Last_Score_Calculation__c, 
            'Score calculation timestamp should be set');
    }
}