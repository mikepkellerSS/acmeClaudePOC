public with sharing class LeadTriggerHandler {
    public void onBeforeInsert(List<Lead> newLeads) {
        ACME_LeadScoringService.calculateLeadScore(newLeads);
    }

    public void onBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldLeadsMap) {
        ACME_LeadScoringService.calculateLeadScore(newLeads);
    }
}