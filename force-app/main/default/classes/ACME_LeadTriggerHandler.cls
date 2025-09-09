public with sharing class ACME_LeadTriggerHandler {
    public static void handleLeadScoring(List<Lead> newLeads) {
        ACME_LeadScoringService.calculateLeadScore(newLeads);
    }
}