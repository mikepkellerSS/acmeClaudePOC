trigger ACME_LeadScoringTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        for (Lead leadRecord : Trigger.new) {
            leadRecord.ACME_Lead_Score__c = 
                ACME_LeadScoringService.calculateLeadScore(leadRecord);
        }
    }
}