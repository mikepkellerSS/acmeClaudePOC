/**
 * Batch job for bulk lead scoring recalculation
 */
public with sharing class ACMELeadScoringBatch implements Database.Batchable<SObject> {
    private ACMELeadScoringService scoringService;

    public ACMELeadScoringBatch() {
        this.scoringService = new ACMELeadScoringService();
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id 
            FROM Lead 
            WHERE IsConverted = false 
            WITH SECURITY_ENFORCED
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        Set<Id> leadIds = new Set<Id>();
        for (Lead lead : scope) {
            leadIds.add(lead.Id);
        }

        Map<Id, Decimal> leadScores = scoringService.calculateLeadScores(leadIds);
        scoringService.updateLeadScores(leadScores);
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('Lead Scoring Batch Job Completed');
    }
}