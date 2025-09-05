public with sharing class ACME_LeadScoringService {
    public static void calculateLeadScore(List<Lead> leads) {
        for (Lead lead : leads) {
            Integer engagementPoints = calculateEngagementPoints(lead);
            Integer demographicPoints = calculateDemographicPoints(lead);
            
            lead.ACME_Engagement_Points__c = engagementPoints;
            lead.ACME_Demographics_Points__c = demographicPoints;
            lead.ACME_Lead_Score__c = Math.min(100, Math.max(0, engagementPoints + demographicPoints));
            lead.ACME_Last_Scored_Date__c = System.now();
        }
    }

    private static Integer calculateEngagementPoints(Lead lead) {
        Integer points = 0;
        
        // Email Engagement
        if (lead.HasOptedOutOfEmail == false) points += 10;
        if (lead.EmailBouncedReason == null) points += 10;
        
        // Web Engagement
        if (lead.Website != null) points += 15;
        
        return Math.min(points, ACME_LeadScoringConstants.ENGAGEMENT_MAX_POINTS);
    }

    private static Integer calculateDemographicPoints(Lead lead) {
        Integer points = 0;
        
        // Company Size
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees > 1000) points += 20;
            else if (lead.NumberOfEmployees > 100) points += 10;
        }
        
        // Industry
        if (String.isNotBlank(lead.Industry)) {
            Set<String> targetIndustries = new Set<String>{'Technology', 'Finance', 'Healthcare'};
            if (targetIndustries.contains(lead.Industry)) points += 20;
        }
        
        return Math.min(points, ACME_LeadScoringConstants.DEMOGRAPHIC_MAX_POINTS);
    }
}