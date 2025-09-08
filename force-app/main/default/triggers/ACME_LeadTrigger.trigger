/**
 * @description Trigger to handle lead scoring on create and update
 * @author Studio Science
 * @date 2025-09-08
 */
trigger ACME_LeadTrigger on Lead (before insert, before update) {
    // Only process if trigger is not already running
    if (!ACME_TriggerHandler.isRunning()) {
        ACME_TriggerHandler.setIsRunning(true);
        
        try {
            // Process leads for scoring
            if (Trigger.isBefore) {
                if (Trigger.isInsert || Trigger.isUpdate) {
                    List<Lead> leadsToScore = Trigger.new;
                    
                    // Calculate scores for new/updated leads
                    for (Lead lead : leadsToScore) {
                        lead.ACME_Lead_Score__c = ACME_LeadScoringService.calculateLeadScore(lead);
                    }
                }
            }
        } finally {
            ACME_TriggerHandler.setIsRunning(false);
        }
    }
}