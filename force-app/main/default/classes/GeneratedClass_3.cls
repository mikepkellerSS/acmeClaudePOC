@isTest
private class ACME_LeadScoreServiceTest {
    
    @isTest
    private static void testCalculateLeadScore() {
        // Test positive scenarios
        Lead lead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'ACME Inc',
            Website_Visits__c = 25,
            Email_Opens__c = 10,
            Email_Clicks__c = 5,
            Industry = 'Technology',
            Title = 'IT Manager',
            AnnualRevenue = 1000000
        );
        
        // Verify the calculated lead score is between 1 and 100
        Integer score = ACME_LeadScoreService.calculateLeadScore(lead);
        System.assert(score >= 1 && score <= 100, 'Lead score should be between 1 and 100');
        
        // Test negative scenarios
        lead.Website_Visits__c = null;
        lead.Email_Opens__c = null;
        lead.Email_Clicks__c = null;
        lead.Industry = null;
        lead.Title = null;
        lead.AnnualRevenue = null;
        
        score = ACME_LeadScoreService.calculateLeadScore(lead);
        System.assert(score >= 1 && score <= 100, 'Lead score should be between 1 and 100');
    }
    
    @isTest
    private static void testGetEngagementScore() {
        // Test positive scenarios
        Lead lead = new Lead(
            Website_Visits__c = 25,
            Email_Opens__c = 10,
            Email_Clicks__c = 5
        );
        
        Integer score = (Integer) Test.invokePrivate(ACME_LeadScoreService.class, 'getEngagementScore', lead);
        System.assertEquals(25, score, 'Engagement score should be 25');
        
        // Test negative scenarios
        lead.Website_Visits__c = null;
        lead.Email_Opens__c = null;
        lead.Email_Clicks__c = null;
        
        score = (Integer) Test.invokePrivate(ACME_LeadScoreService.class, 'getEngagementScore', lead);
        System.assertEquals(0, score, 'Engagement score should be 0');
    }
    
    @isTest
    private static void testGetDemographicScore() {
        // Setup test data
        ScorecardMetric__c metric1 = new ScorecardMetric__c(
            Industry__c = 'Technology',
            Job_Title__c = 'IT Manager',
            Annual_Revenue__c = '1000000',
            Score__c = 25
        );
        insert metric1;
        
        // Test positive scenarios
        Lead lead = new Lead(
            Industry = 'Technology',
            Title = 'IT Manager',
            AnnualRevenue = 1000000
        );
        
        Integer score = (Integer) Test.invokePrivate(ACME_LeadScoreService.class, 'getDemographicScore', lead);
        System.assertEquals(25, score, 'Demographic score should be 25');
        
        // Test negative scenarios
        lead.Industry = null;
        lead.Title = null;
        lead.AnnualRevenue = null;
        
        score = (Integer) Test.invokePrivate(ACME_LeadScoreService.class, 'getDemographicScore', lead);
        System.assertEquals(0, score, 'Demographic score should be 0');
    }
    
    @isTest
    private static void testUpdateLeadScore() {
        // Setup test data
        Lead lead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'ACME Inc',
            Website_Visits__c = 25,
            Email_Opens__c = 10,
            Email_Clicks__c = 5,
            Industry = 'Technology',
            Title = 'IT Manager',
            AnnualRevenue = 1000000
        );
        insert lead;
        
        // Test the updateLeadScore method
        ACME_LeadScoreService.updateLeadScore(lead);
        
        // Retrieve the updated lead and verify the score
        Lead updatedLead = [SELECT Lead_Score__c FROM Lead WHERE Id = :lead.Id];
        System.assertEquals(lead.Lead_Score__c, updatedLead.Lead_Score__c, 'Lead score should be updated');
    }
}