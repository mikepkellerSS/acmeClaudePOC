@IsTest
private class ACME_LeadScoringService_Test {
    @TestSetup
    static void setupTestData() {
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
    
    @IsTest
    static void testLeadScoreCalculation() {
        List<Lead> leads = [SELECT Id, FirstName, LastName, Company 
                            FROM Lead 
                            LIMIT 2];
        
        Test.startTest();
        
        for (Lead lead : leads) {
            Integer score = ACME_LeadScoringService.calculateLeadScore(lead);
            
            System.assert(score >= 1, 'Score should be at least 1');
            System.assert(score <= 100, 'Score should not exceed 100');
        }
        
        ACME_LeadScoringService.updateLeadScores(leads);
        
        Test.stopTest();
        
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
    
    @IsTest
    static void testNullLeadHandling() {
        Test.startTest();
        Integer score = ACME_LeadScoringService.calculateLeadScore(null);
        Test.stopTest();
        
        System.assertEquals(1, score, 'Null lead should return minimum score');
    }
}