/**
 * Test class for ACME_LeadScoringService
 */
@isTest
private class ACME_LeadScoringServiceTest {
    
    /**
     * Setup test data for lead scoring tests
     */
    @testSetup
    static void setupTestData() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Company = 'ACME Tech', 
                Email = 'test1@example.com',
                Industry = 'Technology',
                NumberOfEmployees = 150,
                LeadSource = 'Web'
            ),
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead2', 
                Company = 'Small Business', 
                Email = null,
                Industry = 'Retail',
                NumberOfEmployees = 10,
                LeadSource = 'Referral'
            )
        };
        
        insert testLeads;
    }
    
    /**
     * Test lead scoring calculation
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Retrieve test lead
        Lead testLead = [SELECT Id FROM Lead WHERE LastName = 'Lead1' LIMIT 1];
        
        // Calculate lead score
        Test.startTest();
        Decimal leadScore = ACME_LeadScoringService.calculateLeadScore(testLead.Id);
        Test.stopTest();
        
        // Verify scoring metric created
        ACME_LeadScoringMetric__c scoringMetric = [
            SELECT Score__c, EngagementPoints__c, DemographicPoints__c 
            FROM ACME_LeadScoringMetric__c 
            WHERE LeadId__c = :testLead.Id 
            LIMIT 1
        ];
        
        // Assertions
        System.assert(leadScore > 0, 'Lead score should be positive');
        System.assertEquals(45, leadScore, 'Expected lead score does not match');
        System.assertNotEquals(null, scoringMetric, 'Scoring metric not created');
    }
    
    /**
     * Test null lead ID handling
     */
    @isTest
    static void testNullLeadScoring() {
        Test.startTest();
        Decimal leadScore = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();
        
        System.assertEquals(0, leadScore, 'Null lead should return zero score');
    }
}