trigger ACME_LeadTrigger on Lead (before update, after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        ACME_LeadScoringService.updateLeadScoreOnChange(Trigger.new);
    }
}