public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        List<ACME_LeadScoringMetric__c> scoringMetrics = new List<ACME_LeadScoringMetric__c>();
        
        for (Lead lead : leads) {
            Integer engagementPoints = calculateEngagementPoints(lead);
            Integer demographicPoints = calculateDemographicPoints(lead);
            Integer totalScore = engagementPoints + demographicPoints;
            
            ACME_LeadScoringMetric__c metric = new ACME_LeadScoringMetric__c(
                LeadId__c = lead.Id,
                EngagementPoints__c = engagementPoints,
                DemographicPoints__c = demographicPoints,
                Score__c = totalScore,
                LastCalculatedDate__c = System.now()
            );
            
            scoringMetrics.add(metric);
        }
        
        upsert scoringMetrics LeadId__c;
    }
    
    private static Integer calculateEngagementPoints(Lead lead) {
        Integer points = 0;
        
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 100) {
            points += 20;
        }
        
        if (lead.Email != null) {
            points += 10;
        }
        
        return points;
    }
    
    private static Integer calculateDemographicPoints(Lead lead) {
        Integer points = 0;
        
        if (lead.Industry != null) {
            points += 15;
        }
        
        if (lead.AnnualRevenue != null && lead.AnnualRevenue > 1000000) {
            points += 25;
        }
        
        return points;
    }
}