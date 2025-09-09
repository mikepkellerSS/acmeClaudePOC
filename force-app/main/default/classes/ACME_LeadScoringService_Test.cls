/**
 * @description Test class for ACME Lead Scoring Service
 * @author Studio Science
 * @date 2025-09-09
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Setup test data for lead scoring tests
     */
    @testSetup
    static void createTestLeads() {
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead1',
                Company = 'ACME Corp',
                NumberOfEmployees = 250,
                Industry = 'Technology',
                LeadSource = 'Social Media',
                Website = 'www.testcompany.com'
            ),
            new Lead(
                FirstName = 'Test',
                LastName = 'Lead2',
                Company = 'Small Business',
                NumberOfEmployees = 20,
                Industry = 'Retail'
            )
        };
        insert testLeads;
    }
    
    /**
     * Test lead scoring calculation for engaged lead
     */
    @isTest
    static void testEngagedLeadScoring() {
        Lead testLead = [SELECT Id, Website, HasOptedOutOfEmail, LeadSource, 
                                NumberOfEmployees, Industry 
                         FROM Lead 
                         WHERE LastName = 'Lead1' 
                         LIMIT 1];
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(leadScore > 50, 'Engaged lead should have high score');
    }
    
    /**
     * Test lead scoring calculation for less engaged lead
     */
    @isTest
    static void testLessEngagedLeadScoring() {
        Lead testLead = [SELECT Id, Website, HasOptedOutOfEmail, LeadSource, 
                                NumberOfEmployees, Industry 
                         FROM Lead 
                         WHERE LastName = 'Lead2' 
                         LIMIT 1];
        
        Test.startTest();
        Integer leadScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();
        
        System.assert(leadScore <= 30, 'Less engaged lead should have lower score');
    }
    
    /**
     * Test lead score update functionality
     */
    @isTest
    static void testLeadScoreUpdate() {
        Lead testLead = [SELECT Id FROM Lead WHERE LastName = 'Lead1' LIMIT 1];
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScore(testLead.Id, 75);
        Test.stopTest();
        
        Lead updatedLead = [SELECT ACME_Lead_Score__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(75, updatedLead.ACME_Lead_Score__c, 'Lead score should be updated');
    }
}