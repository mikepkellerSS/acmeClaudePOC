public with sharing class ACME_LeadScoringTriggerHandler {
    public static void handleLeadScoring(List<Lead> newLeads, List<Lead> oldLeads) {
        List<Lead> leadsToScore = new List<Lead>();
        
        for (Lead newLead : newLeads) {
            Lead oldLead = oldLeads != null 
                ? findOldLead(newLead.Id, oldLeads) 
                : null;
            
            if (shouldRecalculateScore(newLead, oldLead)) {
                leadsToScore.add(newLead);
            }
        }
        
        if (!leadsToScore.isEmpty()) {
            ACME_LeadScoringService.calculateLeadScore(leadsToScore);
        }
    }
    
    private static Lead findOldLead(Id newLeadId, List<Lead> oldLeads) {
        for (Lead oldLead : oldLeads) {
            if (oldLead.Id == newLeadId) {
                return oldLead;
            }
        }
        return null;
    }
    
    private static Boolean shouldRecalculateScore(Lead newLead, Lead oldLead) {
        // Define conditions for recalculating lead score
        if (oldLead == null) {
            return true; // New lead
        }
        
        return (newLead.NumberOfEmployees != oldLead.NumberOfEmployees ||
                newLead.Industry != oldLead.Industry);
    }
}