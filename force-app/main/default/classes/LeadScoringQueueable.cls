public with sharing class LeadScoringQueueable implements Queueable {
    private List<Lead> leads;
    
    public LeadScoringQueueable(List<Lead> leads) {
        this.leads = leads;
    }
    
    public void execute(QueueableContext context) {
        ACME_LeadScoringService.calculateLeadScore(leads);
    }
}