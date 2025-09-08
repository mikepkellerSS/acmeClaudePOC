trigger LeadScoringTrigger on Lead (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        ACMELeadScoringTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}