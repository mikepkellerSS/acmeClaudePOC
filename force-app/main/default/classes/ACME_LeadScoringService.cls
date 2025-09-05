public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        try {
            List<ACME_Lead_Scoring_Criteria__mdt> scoringCriteria = 
                [SELECT Criteria_Name__c, Weight__c, Calculation_Logic__c 
                 FROM ACME_Lead_Scoring_Criteria__mdt 
                 WITH SECURITY_ENFORCED];
            
            for (Lead lead : leads) {
                Decimal totalScore = 0;
                
                for (ACME_Lead_Scoring_Criteria__mdt criteria : scoringCriteria) {
                    totalScore += calculateCriteriaScore(lead, criteria);
                }
                
                lead.ACME_Lead_Score__c = Math.min(Math.max(totalScore, 0), 100);
                lead.ACME_Last_Score_Calculation__c = System.now();
            }
        } catch (Exception e) {
            // Log error or handle appropriately
            System.debug('Lead Scoring Error: ' + e.getMessage());
        }
    }
    
    private static Decimal calculateCriteriaScore(Lead lead, ACME_Lead_Scoring_Criteria__mdt criteria) {
        // Implement dynamic scoring logic based on criteria
        // This is a placeholder - replace with actual business logic
        Decimal score = 0;
        
        switch on criteria.Criteria_Name__c {
            when 'Company Size' {
                if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 100) {
                    score = criteria.Weight__c;
                }
            }
            when 'Industry' {
                if (lead.Industry == 'Technology') {
                    score = criteria.Weight__c;
                }
            }
            // Add more criteria as needed
        }
        
        return score;
    }
}