public with sharing class ACME_LeadScoreHandler {
    public void handleLeadScoreUpdate(List<Lead> newLeads, List<Lead> oldLeads) {
        List<Lead> leadsToScore = new List<Lead>();

        for (Lead newLead : newLeads) {
            Lead oldLead = oldLeads != null 
                ? oldLeads[newLeads.indexOf(newLead)] 
                : null;

            if (shouldRecalculateScore(newLead, oldLead)) {
                leadsToScore.add(newLead);
            }
        }

        if (!leadsToScore.isEmpty()) {
            ACME_LeadScoreService.updateLeadScore(leadsToScore);
        }
    }

    private Boolean shouldRecalculateScore(Lead newLead, Lead oldLead) {
        // Define conditions for score recalculation
        return oldLead == null || 
               newLead.NumberOfEmployees != oldLead.NumberOfEmployees ||
               newLead.Industry != oldLead.Industry ||
               newLead.HasOptedOutOfEmail != oldLead.HasOptedOutOfEmail;
    }
}