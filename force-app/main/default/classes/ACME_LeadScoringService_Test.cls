@isTest
private class ACME_LeadScoringService_Test {
    @testSetup
    static void setupTestData() {
        // Create test scoring rules
        List<ACME_LeadScoringRule__mdt> testRules = new List<ACME_LeadScoringRule__mdt>();
        
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Company = 'ACME Corp', 
                NumberOfEmployees = 150,
                Industry = 'Technology'
            ),
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead2', 
                Company = 'Small Business', 
                NumberOfEmployees = 10,
                Industry = 'Retail'
            )
        };
        insert testLeads;
    }
    
    @isTest
    static void testLeadScoreCalculation() {
        List<Lead> leads = [SELECT Id FROM Lead];
        
        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(leads);
        Test.stopTest();
        
        leads = [SELECT ACME_LeadScore__c, ACME_LastScoredDate__c FROM Lead];
        
        System.assertNotEquals(null, leads[0].ACME_LeadScore__c);
        System.assertNotEquals(null, leads[0].ACME_LastScoredDate__c);
    }
}