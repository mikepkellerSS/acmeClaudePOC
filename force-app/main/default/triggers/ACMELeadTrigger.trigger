trigger ACMELeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        for (Lead leadRecord : Trigger.new) {
            leadRecord.ACME_Lead_Score__c = ACMELeadScoringService.calculateLeadScore(leadRecord);
        }
    }
}