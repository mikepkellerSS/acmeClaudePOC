@isTest
private class ACME_LeadScoringService_Test {
    @isTest
    static void testLeadScoring() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Email = 'test@example.com',
            Phone = '1234567890',
            NumberOfEmployees = 150,
            Industry = 'Technology',
            AnnualRevenue = 2000000
        );
        
        Test.startTest();
        insert testLead;
        Test.stopTest();
        
        Lead scoredLead = [SELECT ACME_Lead_Score__c, ACME_Engagement_Points__c, ACME_Demographic_Points__c 
                            FROM Lead 
                            WHERE Id = :testLead.Id];
        
        System.assertEquals(70, scoredLead.ACME_Lead_Score__c, 'Lead score calculation incorrect');
        System.assertEquals(45, scoredLead.ACME_Engagement_Points__c, 'Engagement points incorrect');
        System.assertEquals(25, scoredLead.ACME_Demographic_Points__c, 'Demographic points incorrect');
    }
}