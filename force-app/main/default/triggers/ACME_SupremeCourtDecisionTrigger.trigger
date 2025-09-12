trigger ACME_SupremeCourtDecisionTrigger on ACME_SupremeCourtDecision__c (before insert, before update) {
    ACME_SupremeCourtDecisionTriggerHandler handler = new ACME_SupremeCourtDecisionTriggerHandler();
    handler.run();
}