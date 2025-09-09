@isTest
private class ACME_LeadScoringServiceTest {
    @isTest
    static void testLeadScoring() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            NumberOfEmployees = 200,
            Email = 'test@example.com',
            Industry = 'Technology',
            AnnualRevenue = 2000000
        );
        
        insert testLead;
        
        Test.startTest();
        ACME_LeadScoringService.calculateLeadScore(new List<Lead>{testLead});
        Test.stopTest();
        
        ACME_LeadScoringMetric__c metric = [
            SELECT Score__c, EngagementPoints__c, DemographicPoints__c 
            FROM ACME_LeadScoringMetric__c 
            WHERE LeadId__c = :testLead.Id
        ];
        
        System.assertEquals(75, metric.Score__c, 'Total score should be 75');
        System.assertEquals(30, metric.EngagementPoints__c, 'Engagement points should be 30');
        System.assertEquals(40, metric.DemographicPoints__c, 'Demographic points should be 40');
    }
}