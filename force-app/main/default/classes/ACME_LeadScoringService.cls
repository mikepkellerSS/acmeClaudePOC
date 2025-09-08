/**
 * Core service for calculating lead scores based on configured rules
 */
public with sharing class ACME_LeadScoringService {
    /**
     * Calculate lead score based on configured scoring rules
     * @param leadRecord Lead record to score
     * @return Integer score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        Integer totalScore = 0;
        
        // Retrieve scoring rules from Custom Metadata
        List<ACME_Lead_Scoring_Rule__mdt> scoringRules = 
            ACME_LeadScoringRule.getActiveRules();
        
        // Apply each scoring rule
        for (ACME_Lead_Scoring_Rule__mdt rule : scoringRules) {
            totalScore += evaluateRule(leadRecord, rule);
        }
        
        // Ensure score is between 0-100
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
    /**
     * Evaluate individual scoring rule for a lead
     * @param lead Lead record to evaluate
     * @param rule Scoring rule to apply
     * @return Integer score for this specific rule
     */
    private static Integer evaluateRule(Lead lead, ACME_Lead_Scoring_Rule__mdt rule) {
        try {
            // Use dynamic apex to evaluate rule based on calculation logic
            String calculationLogic = rule.Calculation_Logic__c;
            Integer ruleScore = 0;
            
            // Example rule evaluation (can be expanded)
            if (calculationLogic.contains('Industry')) {
                ruleScore = evaluateIndustryRule(lead, rule);
            } else if (calculationLogic.contains('Company Size')) {
                ruleScore = evaluateCompanySizeRule(lead, rule);
            }
            
            return ruleScore;
        } catch (Exception e) {
            System.Logger.error('Error evaluating scoring rule: ' + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Evaluate industry-specific scoring rule
     */
    private static Integer evaluateIndustryRule(Lead lead, ACME_Lead_Scoring_Rule__mdt rule) {
        // Placeholder for industry-specific scoring logic
        return lead.Industry != null ? (Integer)rule.Weight__c : 0;
    }
    
    /**
     * Evaluate company size scoring rule
     */
    private static Integer evaluateCompanySizeRule(Lead lead, ACME_Lead_Scoring_Rule__mdt rule) {
        // Placeholder for company size scoring logic
        return lead.NumberOfEmployees != null ? (Integer)rule.Weight__c : 0;
    }
    
    /**
     * Update lead score and timestamp
     * @param leadId ID of lead to update
     * @param score Calculated score
     */
    public static void updateLeadScore(Id leadId, Integer score) {
        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Score_Calculation__c = System.now()
        );
        
        try {
            update leadToUpdate;
        } catch (Exception e) {
            System.Logger.error('Error updating lead score: ' + e.getMessage());
        }
    }
}