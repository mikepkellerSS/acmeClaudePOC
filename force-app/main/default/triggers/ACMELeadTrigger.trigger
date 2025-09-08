trigger ACMELeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        List<Decimal> leadScores = ACMELeadScoringService.getLeadScores(Trigger.new);
        
        for (Integer i = 0; i < Trigger.new.size(); i++) {
            Trigger.new[i].ACME_Lead_Score__c = leadScores[i];
        }
    }
}