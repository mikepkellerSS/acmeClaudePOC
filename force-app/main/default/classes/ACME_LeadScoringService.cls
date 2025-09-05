public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScores(List<Lead> leads) {
        List<Lead> leadsToScore = filterLeadsForScoring(leads);
        
        if (leadsToScore.isEmpty()) {
            return;
        }
        
        ACME_LeadScoreCalculator calculator = new ACME_LeadScoreCalculator();
        
        for (Lead lead : leadsToScore) {
            try {
                lead.ACME_Lead_Score__c = calculator.calculateLeadScore(lead);
                lead.ACME_Last_Score_Calculation__c = System.now();
            } catch (Exception e) {
                // Log error, but continue processing other leads
                System.debug('Error scoring lead: ' + e.getMessage());
            }
        }
        
        update leadsToScore;
    }
    
    private static List<Lead> filterLeadsForScoring(List<Lead> leads) {
        List<Lead> eligibleLeads = new List<Lead>();
        
        for (Lead lead : leads) {
            if (isEligibleForScoring(lead)) {
                eligibleLeads.add(lead);
            }
        }
        
        return eligibleLeads;
    }
    
    private static Boolean isEligibleForScoring(Lead lead) {
        // Add your specific eligibility criteria
        return lead.IsConverted == false && 
               lead.Status != 'Disqualified';
    }
}