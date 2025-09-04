@isTest
private class LeadScorecardTest {
    @testSetup
    static void setupTestData() {
        // Create a test lead
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Acme Inc.',
            Industry = 'Technology',
            AnnualRevenue = 1000000,
            NumberOfEmployees = 100,
            NumberOfLocations = 5,
            NumberofProcessedCases__c = 10
        );
        insert testLead;

        // Create a test lead scorecard
        Lead_Scorecard__c testLeadScorecard = new Lead_Scorecard__c(
            Lead__c = testLead.Id,
            Score__c = 0,
            Engagement_Score__c = 0,
            Demographics_Score__c = 0
        );
        insert testLeadScorecard;
    }

    @isTest
    static void testCreateAndUpdateLeadScorecard() {
        // Arrange
        Lead testLead = [SELECT Id, FirstName, LastName, Company, Industry, AnnualRevenue, NumberOfEmployees, NumberOfLocations, NumberofProcessedCases__c FROM Lead LIMIT 1];
        Lead_Scorecard__c testLeadScorecard = [SELECT Id, Lead__c, Score__c, Engagement_Score__c, Demographics_Score__c FROM Lead_Scorecard__c WHERE Lead__c = :testLead.Id LIMIT 1];

        // Act
        testLead.NumberOfEmployees = 150;
        testLead.NumberOfLocations = 10;
        testLead.NumberofProcessedCases__c = 20;
        testLead.Industry = 'Manufacturing';
        testLead.AnnualRevenue = 5000000;
        update testLead;

        testLeadScorecard = [SELECT Id, Lead__c, Score__c, Engagement_Score__c, Demographics_Score__c FROM Lead_Scorecard__c WHERE Lead__c = :testLead.Id LIMIT 1];

        // Assert
        System.assertEquals(30, testLeadScorecard.Engagement_Score__c, 'Engagement score is not calculated correctly');
        System.assertEquals(15, testLeadScorecard.Demographics_Score__c, 'Demographics score is not calculated correctly');
        System.assertEquals(45, testLeadScorecard.Score__c, 'Total score is not calculated correctly');
    }

    @isTest
    static void testLeadScorecardLightningComponent() {
        // Arrange
        Lead testLead = [SELECT Id, FirstName, LastName, Company, Industry, AnnualRevenue, NumberOfEmployees, NumberOfLocations, NumberofProcessedCases__c FROM Lead LIMIT 1];
        Lead_Scorecard__c testLeadScorecard = [SELECT Id, Lead__c, Score__c, Engagement_Score__c, Demographics_Score__c FROM Lead_Scorecard__c WHERE Lead__c = :testLead.Id LIMIT 1];

        // Act
        Test.startTest();
        LeadScorecard component = new LeadScorecard();
        component.engagementScore = testLeadScorecard.Engagement_Score__c;
        component.demographicsScore = testLeadScorecard.Demographics_Score__c;
        component.totalScore = testLeadScorecard.Score__c;
        Test.stopTest();

        // Assert
        System.assertEquals(testLeadScorecard.Engagement_Score__c, component.engagementScore, 'Engagement score is not displayed correctly');
        System.assertEquals(testLeadScorecard.Demographics_Score__c, component.demographicsScore, 'Demographics score is not displayed correctly');
        System.assertEquals(testLeadScorecard.Score__c, component.totalScore, 'Total score is not displayed correctly');
    }

    @isTest
    static void testUpdateLeadScorecardFlow() {
        // Arrange
        Lead testLead = [SELECT Id, FirstName, LastName, Company, Industry, AnnualRevenue, NumberOfEmployees, NumberOfLocations, NumberofProcessedCases__c FROM Lead LIMIT 1];
        Lead_Scorecard__c testLeadScorecard = [SELECT Id, Lead__c, Score__c, Engagement_Score__c, Demographics_Score__c FROM Lead_Scorecard__c WHERE Lead__c = :testLead.Id LIMIT 1];

        // Act
        testLead.NumberOfEmployees = 150;
        testLead.NumberOfLocations = 10;
        testLead.NumberofProcessedCases__c = 20;
        testLead.Industry = 'Manufacturing';
        testLead.AnnualRevenue = 5000000;
        update testLead;

        testLeadScorecard = [SELECT Id, Lead__c, Score__c, Engagement_Score__c, Demographics_Score__c FROM Lead_Scorecard__c WHERE Lead__c = :testLead.Id LIMIT 1];

        // Assert
        System.assertEquals(30, testLeadScorecard.Engagement_Score__c, 'Engagement score is not calculated correctly');
        System.assertEquals(15, testLeadScorecard.Demographics_Score__c, 'Demographics score is not calculated correctly');
        System.assertEquals(45, testLeadScorecard.Score__c, 'Total score is not calculated correctly');
    }

    @isTest
    static void testLeadScorecardPageLayout() {
        // Arrange
        Lead testLead = [SELECT Id, FirstName, LastName, Company, Industry, AnnualRevenue, NumberOfEmployees, NumberOfLocations, NumberofProcessedCases__c FROM Lead LIMIT 1];
        Lead_Scorecard__c testLeadScorecard = [SELECT Id, Lead__c, Score__c, Engagement_Score__c, Demographics_Score__c FROM Lead_Scorecard__c WHERE Lead__c = :testLead.Id LIMIT 1];

        // Act
        PageReference pageRef = Page.LeadPage;
        pageRef.getParameters().put('id', testLead.Id);
        Test.setCurrentPage(pageRef);

        LeadScorecard component = new LeadScorecard();
        component.engagementScore = testLeadScorecard.Engagement_Score__c;
        component.demographicsScore = testLeadScorecard.Demographics_Score__c;
        component.totalScore = testLeadScorecard.Score__c;

        // Assert
        System.assertNotEquals(null, component, 'Lead Scorecard component is not present on the Lead page layout');
        System.assertEquals(testLeadScorecard.Engagement_Score__c, component.engagementScore, 'Engagement score is not displayed correctly');
        System.assertEquals(testLeadScorecard.Demographics_Score__c, component.demographicsScore, 'Demographics score is not displayed correctly');
        System.assertEquals(testLeadScorecard.Score__c, component.totalScore, 'Total score is not displayed correctly');
    }
}