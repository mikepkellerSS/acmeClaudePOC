trigger ACME_LeadTrigger on Lead (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        ACME_LeadTriggerHandler.handleLeadScoring(Trigger.new);
    }
}