/**
 * @description Trigger to invoke lead scoring on lead creation and update
 * @author Studio Science
 * @date 2024-03-15
 */
trigger ACMELeadTrigger on Lead (after insert, after update) {
    // Process leads only in after context
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        for (Lead leadRecord : Trigger.new) {
            // Calculate and update lead score
            Integer leadScore = ACMELeadScoringService.calculateLeadScore(leadRecord);
            ACMELeadScoringService.updateLeadScore(leadRecord.Id, leadScore);
        }
    }
}