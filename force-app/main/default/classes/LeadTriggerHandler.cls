public with sharing class LeadTriggerHandler {
    public static void handleBeforeInsert(List<Lead> newLeads) {
        ACME_LeadScoringService.scoreLead(newLeads);
    }
    
    public static void handleBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadsMap) {
        ACME_LeadScoringService.scoreLead(newLeads);
    }
}