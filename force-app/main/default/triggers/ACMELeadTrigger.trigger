trigger ACMELeadTrigger on Lead (before insert, before update) {
    for (Lead leadRecord : Trigger.new) {
        Decimal score = ACMELeadScoringService.calculateLeadScore(leadRecord);
        leadRecord.Lead_Score__c = score;
    }
}