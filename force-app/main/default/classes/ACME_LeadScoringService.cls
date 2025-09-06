public with sharing class ACME_LeadScoringService {
    public static void scoreLeads(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            lead.Lead_Score__c = score;
        }
        
        // Only update if we have permission
        if (Schema.sObjectType.Lead.isUpdateable()) {
            update leads;
        }
    }

    private static Integer calculateLeadScore(Lead lead) {
        Integer score = 0;

        // Company size scoring
        if (String.isNotBlank(lead.Company)) {
            score += 10;
        }

        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            score += 15;
        }

        // Status scoring
        if (lead.Status == 'Open - Not Contacted') {
            score += 5;
        } else if (lead.Status == 'Working - Contacted') {
            score += 10;
        }

        // Limit score to 100
        return Math.min(score, 100);
    }
}