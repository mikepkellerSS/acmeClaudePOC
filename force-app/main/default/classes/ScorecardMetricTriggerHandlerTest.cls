@isTest
private class ScorecardMetricTriggerHandlerTest {
    @isTest
    static void testUpdateLeadScoreWithNewMetrics() {
        // Arrange
        Lead lead1 = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@acme.com',
            NumberOfEmployees__c = 100,
            LeadScore__c = 0
        );
        insert lead1;

        ScorecardMetric__c metric1 = new ScorecardMetric__c(
            Lead__c = lead1.Id,
            Value__c = 80
        );

        // Act
        Test.startTest();
        insert metric1;
        Test.stopTest();

        // Assert
        Lead updatedLead = [SELECT Id, LeadScore__c FROM Lead WHERE Id = :lead1.Id];
        System.assertEquals(30, updatedLead.LeadScore__c);
    }

    @isTest
    static void testUpdateLeadScoreWithChangedMetrics() {
        // Arrange
        Lead lead2 = new Lead(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'jane.doe@acme.com',
            NumberOfEmployees__c = 20,
            LeadScore__c = 0
        );
        insert lead2;

        ScorecardMetric__c metric2 = new ScorecardMetric__c(
            Lead__c = lead2.Id,
            Value__c = 50
        );
        insert metric2;

        metric2.Value__c = 60;

        // Act
        Test.startTest();
        update metric2;
        Test.stopTest();

        // Assert
        Lead updatedLead = [SELECT Id, LeadScore__c FROM Lead WHERE Id = :lead2.Id];
        System.assertEquals(20, updatedLead.LeadScore__c);
    }

    @isTest
    static void testUpdateLeadScoreWithNoChangedMetrics() {
        // Arrange
        Lead lead3 = new Lead(
            FirstName = 'Bob',
            LastName = 'Smith',
            Email = 'bob.smith@example.com',
            NumberOfEmployees__c = 30,
            LeadScore__c = 0
        );
        insert lead3;

        ScorecardMetric__c metric3 = new ScorecardMetric__c(
            Lead__c = lead3.Id,
            Value__c = 70
        );
        insert metric3;

        // Act
        Test.startTest();
        update metric3;
        Test.stopTest();

        // Assert
        Lead updatedLead = [SELECT Id, LeadScore__c FROM Lead WHERE Id = :lead3.Id];
        System.assertEquals(0, updatedLead.LeadScore__c);
    }

    @isTest
    static void testUpdateLeadScoreWithConvertedLead() {
        // Arrange
        Lead lead4 = new Lead(
            FirstName = 'Alice',
            LastName = 'Johnson',
            Email = 'alice.johnson@acme.com',
            NumberOfEmployees__c = 75,
            ConvertedOpportunityId = 'some-opportunity-id',
            LeadScore__c = 0
        );
        insert lead4;

        ScorecardMetric__c metric4 = new ScorecardMetric__c(
            Lead__c = lead4.Id,
            Value__c = 90
        );

        // Act
        Test.startTest();
        insert metric4;
        Test.stopTest();

        // Assert
        Lead updatedLead = [SELECT Id, LeadScore__c FROM Lead WHERE Id = :lead4.Id];
        System.assertEquals(50, updatedLead.LeadScore__c);
    }

    @isTest
    static void testUpdateLeadScoreWithNullMetrics() {
        // Arrange
        Lead lead5 = new Lead(
            FirstName = 'David',
            LastName = 'Brown',
            Email = 'david.brown@example.com',
            NumberOfEmployees__c = 10,
            LeadScore__c = 0
        );
        insert lead5;

        // Act
        Test.startTest();
        ScorecardMetricTriggerHandler.updateLeadScore(null, null);
        Test.stopTest();

        // Assert
        Lead updatedLead = [SELECT Id, LeadScore__c FROM Lead WHERE Id = :lead5.Id];
        System.assertEquals(0, updatedLead.LeadScore__c);
    }

    @isTest
    static void testCalculateLeadScore() {
        // Arrange
        Lead lead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@acme.com',
            NumberOfEmployees__c = 100,
            ConvertedOpportunityId = 'some-opportunity-id'
        );

        // Act
        Integer score = ScorecardMetricTriggerHandler.calculateLeadScore(lead);

        // Assert
        System.assertEquals(60, score);
    }
}