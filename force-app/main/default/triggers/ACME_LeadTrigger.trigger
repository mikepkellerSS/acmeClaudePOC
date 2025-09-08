/**
 * Lead trigger to invoke lead scoring service
 * Follows Studio Science Trigger Framework best practices
 */
trigger ACME_LeadTrigger on Lead (before update, after update) {
    // Only process in after update context to avoid recursive updates
    if (Trigger.isAfter && Trigger.isUpdate) {
        // Invoke lead scoring service
        ACME_LeadScoringService.updateLeadScoreOnChange(Trigger.new);
    }
}