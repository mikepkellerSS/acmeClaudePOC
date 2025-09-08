trigger ACME_LeadScoreTrigger on Lead (before insert, before update) {
    ACME_LeadScoreTriggerHandler handler = new ACME_LeadScoreTriggerHandler();
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            handler.onBeforeUpdate(Trigger.oldMap, Trigger.new);
        }
    }
}