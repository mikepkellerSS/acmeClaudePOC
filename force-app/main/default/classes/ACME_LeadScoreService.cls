public with sharing class ACME_LeadScoreService {
    public static void updateLeadScore(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leads) {
            Integer calculatedScore = ACME_LeadScoreCalculator.calculateLeadScore(lead);
            
            lead.ACME_Lead_Score__c = calculatedScore;
            lead.ACME_Last_Score_Calculation__c = System.now();
            
            leadsToUpdate.add(lead);
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}