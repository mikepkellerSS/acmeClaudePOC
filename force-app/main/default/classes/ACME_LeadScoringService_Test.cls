/**
 * Test class for ACME_LeadScoringService
 */
@IsTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Setup test data for lead scoring
     */
    @TestSetup
    static void setupTestData() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Company = 'ACME Corp',
                Status = 'Open'
            ),
            new Lead(
                FirstName = 'Another', 
                LastName = 'Lead2', 
                Company = 'Test Company',
                Status = 'Working'
            )
        };
        insert testLeads;
    }
    
    /**
     * Test lead score calculation
     */
    @IsTest
    static void testLeadScoreCalculation() {
        // Retrieve test leads
        List<Lead> leads = [SELECT Id, FirstName, LastName, Company 
                            FROM Lead 
                            LIMIT 2];
        
        Test.startTest();
        
        // Calculate scores for test leads
        for (Lead lead : leads) {
            Integer score = ACME_LeadScoringService.calculateLeadScore(lead);
            
            // Basic assertions
            System.assert(score >= 1, 'Score should be at least 1');
            System.assert(score <= 100, 'Score should not exceed 100');
        }
        
        // Test bulk update of lead scores
        ACME_LeadScoringService.updateLeadScores(leads);
        
        Test.stopTest();
        
        // Verify leads were updated
        List<Lead> updatedLeads = [SELECT ACME_LeadScore__c, ACME_LastScoredDate__c 
                                   FROM Lead 
                                   WHERE Id IN :leads];
        
        for (Lead updatedLead : updatedLeads) {
            System.assertNotEquals(null, updatedLead.ACME_LeadScore__c, 
                'Lead score should be populated');
            System.assertNotEquals(null, updatedLead.ACME_LastScoredDate__c, 
                'Last scored date should be set');
        }
    }
    
    /**
     * Test null lead handling
     */
    @IsTest
    static void testNullLeadHandling() {
        Test.startTest();
        Integer score = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();
        
        System.assertEquals(1, score, 'Null lead should return minimum score');
    }
}