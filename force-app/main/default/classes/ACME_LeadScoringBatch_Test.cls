@isTest
private class ACME_LeadScoringBatch_Test {
    
    @isTest
    static void testLeadScoringBatch() {
        // Create test leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead' + i,
                Email = 'test' + i + '@example.com',
                Company = 'Test Company ' + i
            ));
        }
        insert testLeads;
        
        Test.startTest();
        ACME_LeadScoringBatch batchJob = new ACME_LeadScoringBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        List<Lead> updatedLeads = [
            SELECT ACME_Lead_Score__c 
            FROM Lead 
            WHERE Id IN :testLeads
        ];
        
        for (Lead lead : updatedLeads) {
            System.assertNotEquals(null, lead.ACME_Lead_Score__c, 'Lead score should be updated');
        }
    }
    
    @isTest
    static void testScheduleLeadScoring() {
        Test.startTest();
        ACME_LeadScoringBatch.scheduleLeadScoring();
        Test.stopTest();
        
        List<CronTrigger> scheduledJobs = [
            SELECT Id 
            FROM CronTrigger 
            WHERE JobName = 'Daily Lead Scoring'
        ];
        
        System.assertEquals(1, scheduledJobs.size(), 'Job should be scheduled');
    }
}