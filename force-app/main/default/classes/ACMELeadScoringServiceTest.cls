@isTest
private class ACMELeadScoringServiceTest {
    
    @isTest
    static void testCalculateLeadScore_Positive() {
        // Create test lead
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Number_of_Email_Opens__c = 5,
            Website_Visits__c = 10,
            Content_Downloads__c = 3,
            Company_Size__c = 'Enterprise',
            Industry = 'Technology',
            Title = 'CTO',
            Country = 'United States'
        );

        Test.startTest();
        Integer score = ACMELeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        System.assert(score > 0 && score <= 100, 'Lead score should be between 0 and 100');
    }

    @isTest
    static void testCalculateLeadScore_Null() {
        Test.startTest();
        Integer score = ACMELeadScoringService.calculateLeadScore(null);
        Test.stopTest();

        System.assertEquals(0, score, 'Null lead should return 0 score');
    }

    @isTest
    static void testUpdateLeadScores() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Test1',
                LastName = 'Lead1',
                Company = 'Test Company 1',
                Number_of_Email_Opens__c = 5,
                Website_Visits__c = 10
            ),
            new Lead(
                FirstName = 'Test2',
                LastName = 'Lead2',
                Company = 'Test Company 2',
                Content_Downloads__c = 3
            )
        };

        insert testLeads;

        Test.startTest();
        ACMELeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();

        // Retrieve updated leads
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c, ACME_Lead_Score_Last_Updated__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];

        System.assertEquals(2, updatedLeads.size(), 'All leads should be processed');
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be set');
            System.assertNotEquals(null, lead.ACME_Lead_Score_Last_Updated__c, 'Update timestamp should be set');
        }
    }
}