public with sharing class ACME_LeadScoringService {
    public static Integer calculateLeadScore(Lead leadRecord) {
        Integer totalScore = 0;
        
        List<ACME_Lead_Scoring_Rule__mdt> scoringRules = 
            ACME_LeadScoringRule.getActiveRules();
        
        for (ACME_Lead_Scoring_Rule__mdt rule : scoringRules) {
            totalScore += evaluateRule(leadRecord, rule);
        }
        
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
    private static Integer evaluateRule(Lead lead, ACME_Lead_Scoring_Rule__mdt rule) {
        try {
            String calculationLogic = rule.Calculation_Logic__c;
            Integer ruleScore = 0;
            
            if (calculationLogic != null && calculationLogic.contains('Industry')) {
                ruleScore = evaluateIndustryRule(lead, rule);
            } else if (calculationLogic != null && calculationLogic.contains('Company Size')) {
                ruleScore = evaluateCompanySizeRule(lead, rule);
            }
            
            return ruleScore;
        } catch (Exception e) {
            System.debug('Error evaluating scoring rule: ' + e.getMessage());
            return 0;
        }
    }
    
    private static Integer evaluateIndustryRule(Lead lead, ACME_Lead_Scoring_Rule__mdt rule) {
        return lead.Industry != null ? (Integer)rule.Weight__c : 0;
    }
    
    private static Integer evaluateCompanySizeRule(Lead lead, ACME_Lead_Scoring_Rule__mdt rule) {
        return lead.NumberOfEmployees != null ? (Integer)rule.Weight__c : 0;
    }
    
    public static void updateLeadScore(Id leadId, Integer score) {
        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Score_Calculation__c = System.now()
        );
        
        try {
            update leadToUpdate;
        } catch (Exception e) {
            System.debug('Error updating lead score: ' + e.getMessage());
        }
    }
}