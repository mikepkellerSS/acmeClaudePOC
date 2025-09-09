/**
 * Service class for calculating lead scores based on configurable rules
 * Follows Salesforce best practices for security and performance
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score for a single lead record
     * @param leadRecord The lead to be scored
     * @return Calculated lead score (0-100)
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Retrieve active scoring rules
        List<ACME_LeadScoringRule__mdt> scoringRules = [
            SELECT Criteria__c, Weight__c 
            FROM ACME_LeadScoringRule__mdt 
            WHERE Active__c = true
        ];
        
        Integer totalScore = 0;
        
        // Iterate through scoring rules and apply weights
        for (ACME_LeadScoringRule__mdt rule : scoringRules) {
            totalScore += calculateCriteriaScore(leadRecord, rule);
        }
        
        // Ensure score is between 0 and 100
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
    /**
     * Calculate score for a specific criteria
     * @param lead Lead record to evaluate
     * @param rule Scoring rule to apply
     * @return Score for the specific criteria
     */
    private static Integer calculateCriteriaScore(Lead lead, ACME_LeadScoringRule__mdt rule) {
        Integer criteriaScore = 0;
        
        switch on rule.Criteria__c {
            when 'Company Size' {
                if (lead.NumberOfEmployees != null && lead.NumberOfEmployees >= 100) {
                    criteriaScore = (Integer)(rule.Weight__c * 10);
                }
            }
            when 'Industry' {
                Set<String> targetIndustries = new Set<String>{'Technology', 'Finance', 'Healthcare'};
                if (targetIndustries.contains(lead.Industry)) {
                    criteriaScore = (Integer)(rule.Weight__c * 10);
                }
            }
            when 'Engagement Level' {
                // Placeholder for more complex engagement scoring
                if (lead.HasOptedOutOfEmail == false) {
                    criteriaScore = (Integer)(rule.Weight__c * 10);
                }
            }
            when 'Website Interactions' {
                // Placeholder for website interaction tracking
                if (lead.LeadSource == 'Web') {
                    criteriaScore = (Integer)(rule.Weight__c * 10);
                }
            }
        }
        
        return criteriaScore;
    }
    
    /**
     * Update lead scores for multiple leads
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            
            lead.ACME_LeadScore__c = score;
            lead.ACME_LastScoredDate__c = System.now();
            
            leadsToUpdate.add(lead);
        }
        
        // Perform update with system context to bypass sharing rules
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
}