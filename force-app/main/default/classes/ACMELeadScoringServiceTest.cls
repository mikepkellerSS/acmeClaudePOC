/**
 * @description Test class for ACMELeadScoringService
 * @author Studio Science
 * @date 2024-03-15
 */
@isTest
private class ACMELeadScoringServiceTest {
    
    @testSetup
    static void setupTestData() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1',
                Company = 'ACME Corp',
                NumberOfEmployees = 750,
                Industry = 'Technology',
                Email = 'test1@example.com',
                Phone = '1234567890'
            ),
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead2',
                Company = 'Small Business',
                NumberOfEmployees = 25,
                Industry = 'Retail',
                HasOptedOutOfEmail = true
            )
        };
        insert testLeads;
    }
    
    @isTest
    static void testLeadScoring() {
        // Retrieve test leads
        List<Lead> testLeads = [SELECT Id, NumberOfEmployees, Industry, Email, Phone, HasOptedOutOfEmail FROM Lead];
        
        Test.startTest();
        for (Lead testLead : testLeads) {
            Integer score = ACMELeadScoringService.calculateLeadScore(testLead);
            
            // Assert score is within valid range
            System.assert(score >= 1 && score <= 100, 'Score should be between 1 and 100');
            
            // Update lead score
            ACMELeadScoringService.updateLeadScore(testLead.Id, score);
        }
        Test.stopTest();
        
        // Verify leads were updated
        List<Lead> updatedLeads = [SELECT ACME_Lead_Score__c FROM Lead];
        System.assertEquals(2, updatedLeads.size(), 'All leads should be processed');
    }
    
    @isTest
    static void testEdgeCases() {
        // Test lead with minimal information
        Lead minimalLead = new Lead(
            FirstName = 'Minimal',
            LastName = 'Lead',
            Company = 'No Info'
        );
        
        Test.startTest();
        Integer score = ACMELeadScoringService.calculateLeadScore(minimalLead);
        Test.stopTest();
        
        // Assert minimum score
        System.assertEquals(1, score, 'Minimal lead should have minimum score');
    }
}