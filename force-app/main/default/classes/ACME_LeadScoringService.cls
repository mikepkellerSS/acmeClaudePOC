/**
 * Service class for calculating lead scores based on configurable criteria
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on custom metadata criteria
     * @param leadRecord The lead record to score
     * @return Integer representing the lead score (1-100)
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Validate input
        if (leadRecord == null) {
            return 1;
        }

        Integer score = 0;
        
        // Retrieve scoring criteria from Custom Metadata
        List<ACME_LeadScoringCriteria__mdt> criteria = 
            ACME_LeadScoringCriteria__mdt.getAll().values();
        
        // Iterate through scoring criteria
        for (ACME_LeadScoringCriteria__mdt criterion : criteria) {
            if (meetsCriterion(leadRecord, criterion)) {
                score += Integer.valueOf(criterion.Weight__c);
            }
        }
        
        // Ensure score is between 1-100
        return Math.min(Math.max(score, 1), 100);
    }

    /**
     * Check if lead meets a specific scoring criterion
     * @param lead The lead record to evaluate
     * @param criterion The scoring criterion to check
     * @return Boolean indicating if criterion is met
     */
    private static Boolean meetsCriterion(Lead lead, ACME_LeadScoringCriteria__mdt criterion) {
        try {
            // Dynamic field evaluation using reflection
            Object fieldValue = lead.get(criterion.Field__c);
            
            // Basic criterion matching logic
            if (fieldValue != null) {
                // Add more sophisticated matching logic as needed
                return true;
            }
            
            return false;
        } catch (Exception e) {
            // Log error and return false
            System.debug(LoggingLevel.ERROR, 
                'Error evaluating lead scoring criterion: ' + e.getMessage());
            return false;
        }
    }

    /**
     * Update lead score and last scored date
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            
            // Create new lead record for update
            Lead updatedLead = new Lead(Id = lead.Id);
            updatedLead.ACME_LeadScore__c = score;
            updatedLead.ACME_LastScoredDate__c = System.now();
            
            leadsToUpdate.add(updatedLead);
        }
        
        // Perform update with security check
        if (!leadsToUpdate.isEmpty()) {
            SObjectAccessDecision securityDecision = Security.stripInaccessible(
                AccessType.UPDATABLE, leadsToUpdate
            );
            
            update securityDecision.getRecords();
        }
    }
}