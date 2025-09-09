public with sharing class ACME_LeadTriggerHandler {
    public static void handleLeadScoring(List<Lead> leads) {
        ACME_LeadScoringService.calculateLeadScore(leads);
    }
}