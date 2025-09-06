/**
 * Handles lead scoring calculation based on predefined rules
 */
public with sharing class ACME_LeadScoreCalculator {
    
    /**
     * Calculate lead score based on custom metadata rules
     * @param lead The lead to be scored
     * @return Integer representing the calculated lead score
     */
    public static Integer calculateLeadScore(Lead lead) {
        if (lead == null) {
            return 0;
        }

        Integer totalScore = 0;
        
        // Retrieve scoring rules from Custom Metadata
        List<ACME_LeadScoringRule__mdt> rules = 
            [SELECT Metric__c, Weight__c, Threshold__c 
             FROM ACME_LeadScoringRule__mdt 
             WITH SECURITY_ENFORCED];
        
        for (ACME_LeadScoringRule__mdt rule : rules) {
            if (meetsRuleCriteria(lead, rule)) {
                totalScore += Integer.valueOf(rule.Weight__c);
            }
        }
        
        return Math.min(100, Math.max(0, totalScore));
    }
    
    /**
     * Determine if a lead meets a specific scoring rule
     * @param lead The lead to evaluate
     * @param rule The scoring rule to apply
     * @return Boolean indicating if the rule criteria is met
     */
    private static Boolean meetsRuleCriteria(Lead lead, ACME_LeadScoringRule__mdt rule) {
        switch on rule.Metric__c {
            when 'INDUSTRY' {
                return lead.Industry != null && 
                       lead.Industry == rule.Threshold__c;
            }
            when 'EMPLOYEE_COUNT' {
                return lead.NumberOfEmployees != null && 
                       lead.NumberOfEmployees >= Integer.valueOf(rule.Threshold__c);
            }
            when 'EMAIL_ENGAGEMENT' {
                // Example engagement logic
                return lead.HasOptedOutOfEmail == false;
            }
            when else {
                return false;
            }
        }
    }
}