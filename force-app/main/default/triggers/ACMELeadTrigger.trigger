trigger ACMELeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ACMELeadScoringService.scoreLead(Trigger.new);
    }
}