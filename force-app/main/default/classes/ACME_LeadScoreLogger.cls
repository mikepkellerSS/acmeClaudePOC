public with sharing class ACME_LeadScoreLogger {
    public static void logLeadScoreChange(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        List<ACME_Lead_Scoring_Metric__c> scoringMetrics = new List<ACME_Lead_Scoring_Metric__c>();
        
        for (Lead newLead : newLeads) {
            Lead oldLead = oldLeads != null ? oldLeads.get(newLead.Id) : null;
            
            if (oldLead == null || newLead.ACME_Lead_Score__c != oldLead.ACME_Lead_Score__c) {
                ACME_Lead_Scoring_Metric__c metric = new ACME_Lead_Scoring_Metric__c(
                    Lead__c = newLead.Id,
                    Previous_Score__c = oldLead != null ? oldLead.ACME_Lead_Score__c : null,
                    New_Score__c = newLead.ACME_Lead_Score__c,
                    Timestamp__c = System.now()
                );
                scoringMetrics.add(metric);
            }
        }
        
        if (!scoringMetrics.isEmpty()) {
            insert scoringMetrics;
        }
    }
}