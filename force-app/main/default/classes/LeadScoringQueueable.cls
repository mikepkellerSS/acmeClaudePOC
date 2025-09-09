/**
 * Queueable job for asynchronous lead scoring
 */
public with sharing class LeadScoringQueueable implements Queueable, Database.AllowsCallouts {
    private final Id leadId;
    
    /**
     * Constructor to set lead ID for scoring
     * @param leadId The ID of the lead to score
     */
    public LeadScoringQueueable(Id leadId) {
        this.leadId = leadId;
    }
    
    /**
     * Execute lead scoring asynchronously
     * @param context Queueable execution context
     */
    public void execute(QueueableContext context) {
        if (leadId != null) {
            try {
                // Calculate lead score
                ACME_LeadScoringService.calculateLeadScore(leadId);
            } catch (Exception e) {
                // Log error without throwing
                System.debug(LoggingLevel.ERROR, 
                    'Lead Scoring Error for Lead ' + leadId + ': ' + e.getMessage());
            }
        }
    }
}