/**
 * Test class for ACME_LeadScoringService to ensure comprehensive coverage
 */
@isTest
private class ACME_LeadScoringService_Test {
    
    /**
     * Test lead score calculation with various scenarios
     */
    @isTest
    static void testLeadScoreCalculation() {
        // Create test leads with different profiles
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Tech',
                LastName = 'Lead',
                Company = 'TechCorp',
                Email_Opens__c = 10,
                Website_Visits__c = 5,
                Content_Downloads__c = 3,
                Number_of_Employees__c = 600,
                Industry = 'Technology',
                Title = 'CTO'
            ),
            new Lead(
                FirstName = 'Small',
                LastName = 'Business',
                Company = 'LocalShop',
                Email_Opens__c = 2,
                Website_Visits__c = 1,
                Content_Downloads__c = 0,
                Number_of_Employees__c = 10,
                Industry = 'Retail',
                Title = 'Owner'
            )
        };

        Test.startTest();
        for (Lead lead : testLeads) {
            Integer score = ACME_LeadScoringService.calculateLeadScore(lead);
            System.assertNotEquals(null, score, 'Score should not be null');
            System.assert(score >= 0 && score <= 100, 'Score should be between 0 and 100');
        }
        Test.stopTest();
    }

    /**
     * Test bulk lead score updates
     */
    @isTest
    static void testBulkLeadScoreUpdate() {
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Bulk',
                LastName = 'Lead ' + i,
                Company = 'Test Company ' + i,
                Email_Opens__c = 5,
                Website_Visits__c = 3
            ));
        }

        Test.startTest();
        ACME_LeadScoringService.updateLeadScores(testLeads);
        Test.stopTest();

        // Verify scores were calculated
        for (Lead lead : testLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be calculated');
        }
    }
}