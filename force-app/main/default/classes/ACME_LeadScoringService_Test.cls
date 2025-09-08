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
    static void createTestData() {
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1',
                Company = 'ACME Corp',
                Email = 'test1@example.com',
                NumberOfEmployees = 500,
                Industry = 'Technology',
                Title = 'Director of Operations'
            ),
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead2',
                Company = 'Small Business',
                Email = null,
                NumberOfEmployees = 50,
                Industry = 'Retail',
                Title = 'Sales Representative'
            )
        };
        insert testLeads;
    }

    /**
     * Test successful lead scoring calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Arrange
        Lead testLead = [SELECT Id FROM Lead WHERE LastName = 'Lead1' LIMIT 1];

        // Act
        Test.startTest();
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead.Id);
        Test.stopTest();

        // Assert
        Lead updatedLead = [
            SELECT ACME_Lead_Score__c, ACME_Last_Scored_Date__c 
            FROM Lead 
            WHERE Id = :testLead.Id
        ];

        System.assertNotEquals(null, updatedLead.ACME_Lead_Score__c, 'Lead score should be calculated');
        System.assert(calculatedScore >= 0 && calculatedScore <= 100, 'Score should be between 0-100');
        System.assertNotEquals(null, updatedLead.ACME_Last_Scored_Date__c, 'Scoring date should be set');
    }

    /**
     * Test error handling for null lead ID
     */
    @isTest
    static void testNullLeadIdHandling() {
        // Act & Assert
        try {
            ACME_LeadScoringService.calculateLeadScore(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (ACME_LeadScoringService.ACME_LeadScoringException e) {
            System.assert(true, 'Correct exception was thrown');
        }
    }
}