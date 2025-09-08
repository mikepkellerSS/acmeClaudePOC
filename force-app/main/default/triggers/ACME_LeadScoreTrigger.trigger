trigger ACME_LeadScoreTrigger on Lead (before insert, before update) {
    for (Lead leadRecord : Trigger.new) {
        Integer calculatedScore = ACME_LeadScoringService.calculateLeadScore(leadRecord);
        
        ACME_LeadScoringService.updateLeadScore(leadRecord.Id, calculatedScore);
    }
}