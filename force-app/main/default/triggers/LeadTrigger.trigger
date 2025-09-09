trigger LeadTrigger on Lead (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            LeadTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            LeadTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}