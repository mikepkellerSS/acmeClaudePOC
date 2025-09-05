@isTest
private class ACMELeadScoringServiceTest {
    @testSetup
    static void setupTestData() {
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead1', 
                Company = 'ACME Corp', 
                Industry = 'Technology',
                NumberOfEmployees = 500,
                ACME_Engagement_Points__c = 25
            ),
            new Lead(
                FirstName = 'Test', 
                LastName = 'Lead2', 
                Company = 'Global Inc', 
                Industry = 'Finance',
                NumberOfEmployees = 50,
                ACME_Engagement_Points__c = 10
            )
        };
        insert testLeads;
    }

    @isTest
    static void testLeadScoreCalculation() {
        List<Lead> testLeads = [SELECT Id FROM Lead];
        Set<Id> leadIds = new Set<Id>();
        
        for (Lead l : testLeads) {
            leadIds.add(l.Id);
        }

        Test.startTest();
        ACMELeadScoringService scoringService = new ACMELeadScoringService();
        Map<Id, Decimal> leadScores = scoringService.calculateLeadScores(leadIds);
        scoringService.updateLeadScores(leadScores);
        Test.stopTest();

        List<Lead> updatedLeads = [
            SELECT Id, ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id IN :leadIds
        ];

        System.assertEquals(2, updatedLeads.size(), 'All leads should be scored');
        for (Lead l : updatedLeads) {
            System.assertNotEquals(null, l.ACME_Lead_Score__c, 'Lead score should be calculated');
        }
    }
}