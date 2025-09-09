@isTest
private class ACME_LeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            NumberOfEmployees = 200,
            Industry = 'Technology',
            AnnualRevenue = 2000000
        );
        insert testLead;
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(new List<Lead>{testLead});
        Test.stopTest();
        
        List<ACME_LeadScoringMetric__c> metrics = [
            SELECT Score__c, EngagementPoints__c, DemographicPoints__c 
            FROM ACME_LeadScoringMetric__c 
            WHERE LeadId__c = :testLead.Id
        ];
        
        System.assertNotEquals(0, metrics.size(), 'Scoring metric should be created');
        System.assertEquals(55, metrics[0].Score__c, 'Score should be calculated correctly');
    }
}