@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead', 
                Company = 'ACME Corp', 
                Email = 'test@example.com',
                NumberOfEmployees = 500,
                Industry = 'Technology',
                Country = 'United States'
            )
        };
        
        insert testLeads;
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScores(testLeads);
        Test.stopTest();
        
        // Retrieve updated lead
        Lead updatedLead = [
            SELECT ACME_Lead_Score__c, 
                   ACME_Engagement_Score__c, 
                   ACME_Demographics_Score__c 
            FROM Lead 
            WHERE Id = :testLeads[0].Id
        ];
        
        System.assert(updatedLead.ACME_Lead_Score__c > 0, 'Lead score should be calculated');
        System.assert(updatedLead.ACME_Engagement_Score__c > 0, 'Engagement score should be calculated');
        System.assert(updatedLead.ACME_Demographics_Score__c > 0, 'Demographics score should be calculated');
    }
}