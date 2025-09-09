public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer engagementPoints = calculateEngagementPoints(lead);
            Integer demographicPoints = calculateDemographicPoints(lead);
            
            lead.ACME_Engagement_Points__c = engagementPoints;
            lead.ACME_Demographic_Points__c = demographicPoints;
            lead.ACME_Lead_Score__c = Math.min(100, engagementPoints + demographicPoints);
            lead.ACME_Score_Last_Updated__c = System.now();
        }
    }
    
    private static Integer calculateEngagementPoints(Lead lead) {
        Integer points = 0;
        
        if (lead.NumberOfEmployees != null) {
            points += lead.NumberOfEmployees >= 100 ? 20 : 10;
        }
        
        if (lead.Email != null) points += 15;
        if (lead.Phone != null) points += 10;
        
        return points;
    }
    
    private static Integer calculateDemographicPoints(Lead lead) {
        Integer points = 0;
        
        if (lead.Industry != null) {
            points += getIndustryPoints(lead.Industry);
        }
        
        if (lead.AnnualRevenue != null) {
            points += lead.AnnualRevenue > 1000000 ? 25 : 10;
        }
        
        return points;
    }
    
    private static Integer getIndustryPoints(String industry) {
        Map<String, Integer> industryPointsMap = new Map<String, Integer>{
            'Technology' => 25,
            'Finance' => 20,
            'Healthcare' => 15,
            'Manufacturing' => 10
        };
        
        return industryPointsMap.containsKey(industry) ? 
            industryPointsMap.get(industry) : 5;
    }
}