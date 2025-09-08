trigger ACMELeadTrigger on Lead (before insert, before update) {
    for (Lead leadRecord : Trigger.new) {
        leadRecord.ACME_Lead_Score__c = ACMELeadScoringService.calculateLeadScore(leadRecord);
    }
}