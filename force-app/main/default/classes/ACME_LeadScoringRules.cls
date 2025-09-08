/**
 * @description Configurable lead scoring rules and metrics
 */
public with sharing class ACME_LeadScoringRules {
    
    /**
     * Retrieves scoring metrics from custom metadata
     * @return List of scoring metric configurations
     */
    public static List<ACME_Scoring_Metric__mdt> getScoringMetrics() {
        try {
            return [
                SELECT 
                    MasterLabel, 
                    Points__c, 
                    Criteria__c, 
                    Category__c 
                FROM ACME_Scoring_Metric__mdt 
                WHERE IsActive__c = true
                ORDER BY Points__c DESC
            ];
        } catch (Exception e) {
            // Log error and return empty list
            System.Logger.error('Error retrieving scoring metrics: ' + e.getMessage());
            return new List<ACME_Scoring_Metric__mdt>();
        }
    }

    /**
     * Calculates points based on specific lead attributes
     * @param lead Lead record to evaluate
     * @return Decimal total points
     */
    public static Decimal calculateDemographicPoints(Lead lead) {
        Decimal points = 0;
        
        // Company size scoring
        if (lead.NumberOfEmployees != null) {
            points += lead.NumberOfEmployees >= 500 ? 20 : 
                      lead.NumberOfEmployees >= 100 ? 10 : 5;
        }
        
        // Industry scoring
        Map<String, Decimal> industryScores = new Map<String, Decimal>{
            'Technology' => 25,
            'Finance' => 20,
            'Healthcare' => 15,
            'Manufacturing' => 10
        };
        
        if (lead.Industry != null && industryScores.containsKey(lead.Industry)) {
            points += industryScores.get(lead.Industry);
        }
        
        return points;
    }

    /**
     * Calculates engagement points from marketing interactions
     * @param lead Lead record to evaluate
     * @return Decimal total engagement points
     */
    public static Decimal calculateEngagementPoints(Lead lead) {
        Decimal points = 0;
        
        // Website visit scoring
        if (lead.Website_Visits__c != null) {
            points += lead.Website_Visits__c >= 10 ? 25 : 
                      lead.Website_Visits__c >= 5 ? 15 : 5;
        }
        
        // Email interaction scoring
        if (lead.Email_Opens__c != null) {
            points += lead.Email_Opens__c >= 5 ? 20 : 
                      lead.Email_Opens__c >= 2 ? 10 : 0;
        }
        
        return points;
    }
}