public with sharing class ACME_LeadScoringService {
    public static Integer calculateLeadScore(Lead leadRecord) {
        List<ACME_LeadScoringRule__mdt> scoringRules = [
            SELECT Criteria__c, Weight__c 
            FROM ACME_LeadScoringRule__mdt 
            WHERE Active__c = true
        ];
        
        Integer totalScore = 0;
        
        for (ACME_LeadScoringRule__mdt rule : scoringRules) {
            totalScore += calculateCriteriaScore(leadRecord, rule);
        }
        
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
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
            when 'Engagement' {
                if (lead.HasOptedOutOfEmail == false) {
                    criteriaScore = (Integer)(rule.Weight__c * 10);
                }
            }
        }
        
        return criteriaScore;
    }
    
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            
            lead.ACME_LeadScore__c = score;
            lead.ACME_LastScoredDate__c = System.now();
            
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
}