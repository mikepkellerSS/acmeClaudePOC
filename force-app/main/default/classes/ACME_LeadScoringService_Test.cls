@isTest
private class ACME_LeadScoringService_Test {
    
    @testSetup
    static void setupTestData() {
        List<SObject> metrics = new List<SObject>{
            new ACME_Lead_Scoring_Metric__c(
                Name = 'Email Engagement',
                ACME_Weight__c = 0.5,
                ACME_Criteria_Type__c = 'Engagement',
                IsActive__c = true
            ),
            new ACME_Lead_Scoring_Metric__c(
                Name = 'Company Size',
                ACME_Weight__c = 0.5,
                ACME_Criteria_Type__c = 'Demographics',
                IsActive__c = true
            )
        };
        insert metrics;
    }

    @isTest
    static void testLeadScoreCalculation() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            Email = 'test@example.com',
            NumberOfEmployees = 100,
            Country = 'United States',
            Title = 'Director'
        );

        Test.startTest();
        Decimal calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        System.assert(calculatedScore >= 1 && calculatedScore <= 100, 
            'Lead score should be between 1 and 100');
    }

    @isTest
    static void testLeadScoreWithMinimalData() {
        Lead testLead = new Lead(
            FirstName = 'Minimal',
            LastName = 'Lead',
            Company = 'Small Company'
        );

        Test.startTest();
        Decimal calculatedScore = ACME_LeadScoringService.calculateLeadScore(testLead);
        Test.stopTest();

        System.assert(calculatedScore < 50, 'Lead score should be low with minimal data');
    }

    @isTest
    static void testBulkLeadScoreUpdate() {
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Bulk',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Email = 'bulk' + i + '@example.com'
            ));
        }
        insert testLeads;

        Test.startTest();
        ACME_LeadScoringService.updateLeadScoreOnChange(testLeads);
        Test.stopTest();

        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];

        System.assertEquals(200, updatedLeads.size(), 'All leads should be processed');
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 
                'Lead score should be calculated');
        }
    }
}