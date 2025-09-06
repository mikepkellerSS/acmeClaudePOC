trigger ACME_LeadTrigger on Lead (before insert, before update) {
    for (Lead leadRecord : Trigger.new) {
        // Calculate lead score
        Decimal score = ACME_LeadScoringService.calculateLeadScore(leadRecord);
        
        // Optionally set the score on the lead record
        leadRecord.ACME_Weight__c = score;
    }
}