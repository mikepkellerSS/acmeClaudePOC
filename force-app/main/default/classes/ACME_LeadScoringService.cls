public with sharing class ACME_LeadScoringService {
    
    public static Decimal calculateLeadScore(Lead lead) {
        if (lead == null) {
            return 0;
        }

        List<SObject> scoringMetrics = getActiveScoringMetrics();
        
        Decimal totalScore = 0;
        Decimal maxPossibleScore = 0;

        for (SObject metricSObject : scoringMetrics) {
            Decimal weight = (Decimal)metricSObject.get('ACME_Weight__c');
            String criteriaType = (String)metricSObject.get('ACME_Criteria_Type__c');
            
            Decimal metricScore = calculateMetricScore(lead, criteriaType);
            totalScore += metricScore * weight;
            maxPossibleScore += 100 * weight;
        }

        if (maxPossibleScore > 0) {
            return Math.min(Math.max((totalScore / maxPossibleScore) * 100, 1), 100).setScale(0);
        }

        return 0;
    }

    private static List<SObject> getActiveScoringMetrics() {
        return [
            SELECT Name, 
                   ACME_Weight__c, 
                   ACME_Criteria_Type__c 
            FROM ACME_Lead_Scoring_Metric__c 
            WHERE IsActive__c = true 
            ORDER BY ACME_Weight__c DESC
        ];
    }

    private static Decimal calculateMetricScore(Lead lead, String criteriaType) {
        switch on criteriaType {
            when 'Engagement' {
                return calculateEngagementScore(lead);
            }
            when 'Demographics' {
                return calculateDemographicScore(lead);
            }
            when else {
                return 0;
            }
        }
    }

    private static Decimal calculateEngagementScore(Lead lead) {
        Decimal engagementScore = 0;

        if (lead.HasOptedOutOfEmail == false) {
            engagementScore += 20;
        }
        
        if (lead.NumberOfEmployees != null && lead.NumberOfEmployees > 50) {
            engagementScore += 30;
        }

        if (lead.Email != null) {
            engagementScore += 50;
        }

        return Math.min(engagementScore, 100);
    }

    private static Decimal calculateDemographicScore(Lead lead) {
        Decimal demographicScore = 0;

        if (lead.Country != null) {
            demographicScore += 40;
        }

        if (lead.Title != null) {
            demographicScore += 60;
        }

        return Math.min(demographicScore, 100);
    }

    public static void updateLeadScoreOnChange(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leads) {
            Decimal calculatedScore = calculateLeadScore(lead);
            
            if (lead.ACME_Lead_Score__c != calculatedScore) {
                lead.ACME_Lead_Score__c = calculatedScore;
                leadsToUpdate.add(lead);
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
}