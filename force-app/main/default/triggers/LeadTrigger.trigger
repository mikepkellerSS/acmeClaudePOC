trigger LeadTrigger on Lead (before insert, before update) {
    LeadTriggerHandler handler = new LeadTriggerHandler();
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}