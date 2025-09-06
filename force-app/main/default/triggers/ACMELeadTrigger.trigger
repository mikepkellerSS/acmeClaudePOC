trigger ACMELeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            for (Lead leadRecord : Trigger.new) {
                Decimal leadScore = ACMELeadScoringService.calculateLeadScore(leadRecord);
                leadRecord.ACME_Lead_Score__c = leadScore;
            }
        }
    }
}