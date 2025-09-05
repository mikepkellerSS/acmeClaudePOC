@isTest
private class ACME_LeadScoreHandler_Test {
    
    @testSetup
    static void createTestData() {
        // Create test leads with various attributes
        List<Lead> testLeads = new List<Lead>{
            new Lead(
                FirstName = 'Tech',
                LastName = 'CEO',
                Company = 'Large Tech Corp',
                Email = 'ceo@techcorp.com',
                NumberOfEmployees = 1500,
                Industry = 'Technology',
                Title = 'CEO',
                Website = 'www.techcorp.com'
            ),
            new Lead(
                FirstName = 'Small',
                LastName = 'Business',
                Company = 'Local Shop',
                Email = null,
                NumberOfEmployees = 10,
                Industry = 'Retail',
                Title = 'Owner'
            )
        };
        
        insert testLeads;
    }
    
    @isTest
    static void testLeadScoreCalculation() {
        // Retrieve test leads
        List<Lead> leads = [SELECT Id FROM Lead];
        
        Test.startTest();
        
        // Calculate scores for both leads
        for (Lead lead : leads) {
            Decimal score = ACME_LeadScoreHandler.calculateLeadScore(lead.Id);
            
            // Assert score is within expected range
            System.assert(score >= 0 && score <= 100, 'Score should be between 0 and 100');
        }
        
        Test.stopTest();
        
        // Verify leads were updated
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c, ACME_Score_Last_Updated__c 
            FROM Lead
        ];
        
        for (Lead updatedLead : updatedLeads) {
            System.assertNotEquals(null, updatedLead.ACME_Lead_Score__c, 'Lead score should be populated');
            System.assertNotEquals(null, updatedLead.ACME_Score_Last_Updated__c, 'Score update timestamp should be set');
        }
    }
    
    @isTest
    static void testInvalidLeadScoring() {
        Test.startTest();
        
        // Test null lead ID
        Decimal nullScore = ACME_LeadScoreHandler.calculateLeadScore(null);
        System.assertEquals(0, nullScore, 'Null lead should return zero score');
        
        // Test non-existent lead ID
        Decimal invalidScore = ACME_LeadScoreHandler.calculateLeadScore(UserInfo.getUserId());
        System.assertEquals(0, invalidScore, 'Invalid lead should return zero score');
        
        Test.stopTest();
    }
}