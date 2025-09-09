public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        List<ACME_LeadScoringMetric__c> scoringMetrics = new List<ACME_LeadScoringMetric__c>();
        
        for (Lead lead : leads) {
            ACME_LeadScoringMetric__c metric = new ACME_LeadScoringMetric__c();
            metric.LeadId__c = lead.Id;
            metric.EngagementPoints__c = calculateEngagementPoints(lead);
            metric.DemographicPoints__c = calculateDemographicPoints(lead);
            metric.Score__c = calculateTotalScore(metric);
            metric.LastCalculatedDate__c = System.now();
            
            scoringMetrics.add(metric);
        }
        
        if (!scoringMetrics.isEmpty()) {
            upsert scoringMetrics;
        }
    }
    
    private static Decimal calculateEngagementPoints(Lead lead) {
        Decimal points = 0;
        
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 100) {
            points += 20;
        }
        
        if (lead.Email != null) {
            points += 10;
        }
        
        return points;
    }
    
    private static Decimal calculateDemographicPoints(Lead lead) {
        Decimal points = 0;
        
        if (lead.Industry != null) {
            points += 15;
        }
        
        if (lead.AnnualRevenue != null && lead.AnnualRevenue > 1000000) {
            points += 25;
        }
        
        return points;
    }
    
    private static Decimal calculateTotalScore(ACME_LeadScoringMetric__c metric) {
        Decimal totalPoints = metric.EngagementPoints__c + metric.DemographicPoints__c;
        return Math.min(100, totalPoints);
    }
}