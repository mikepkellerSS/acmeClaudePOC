public with sharing class ACME_LeadScoringBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        ACME_LeadScoringBatch leadScoringBatch = new ACME_LeadScoringBatch();
        Database.executeBatch(leadScoringBatch, 200);
    }

    public static void scheduleLeadScoring() {
        // Schedule the batch job to run daily at midnight
        String cronExpression = '0 0 0 * * ?';
        System.schedule('Daily Lead Scoring', cronExpression, new ACME_LeadScoringBatchScheduler());
    }
}