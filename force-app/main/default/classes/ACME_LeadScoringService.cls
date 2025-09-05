/**
 * @description Service class for calculating lead scores
 * @author Studio Science
 * @date 2025-09-05
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead scores based on engagement and demographic criteria
     * @param leads List of leads to score
     */
    public static void calculateLeadScore(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return;
        }

        // Retrieve scoring criteria from custom metadata
        List<ACME_Scoring_Criteria__mdt> scoringCriteria = 
            [SELECT Score_Type__c, Criteria_Field__c, 
                    Minimum_Value__c, Maximum_Value__c, Score_Points__c 
             FROM ACME_Scoring_Criteria__mdt];

        // Process each lead
        for (Lead lead : leads) {
            Integer engagementScore = calculateEngagementScore(lead, scoringCriteria);
            Integer demographicScore = calculateDemographicScore(lead, scoringCriteria);
            
            lead.ACME_Engagement_Score__c = engagementScore;
            lead.ACME_Demographic_Score__c = demographicScore;
            lead.ACME_Lead_Score__c = engagementScore + demographicScore;
            lead.ACME_Score_Last_Updated__c = System.now();
        }
    }

    /**
     * Calculate engagement score for a lead
     * @param lead Individual lead record
     * @param scoringCriteria List of scoring criteria
     * @return Calculated engagement score
     */
    private static Integer calculateEngagementScore(
        Lead lead, 
        List<ACME_Scoring_Criteria__mdt> scoringCriteria
    ) {
        Integer engagementScore = 0;
        
        for (ACME_Scoring_Criteria__mdt criteria : scoringCriteria) {
            if (criteria.Score_Type__c == 'Engagement') {
                Object fieldValue = lead.get(criteria.Criteria_Field__c);
                
                if (fieldValue != null) {
                    if (fieldValue instanceof Integer) {
                        Integer intValue = (Integer)fieldValue;
                        if (intValue >= criteria.Minimum_Value__c 
                            && intValue <= criteria.Maximum_Value__c) {
                            engagementScore += criteria.Score_Points__c.intValue();
                        }
                    }
                }
            }
        }
        
        return Math.min(engagementScore, 100);
    }

    /**
     * Calculate demographic score for a lead
     * @param lead Individual lead record
     * @param scoringCriteria List of scoring criteria
     * @return Calculated demographic score
     */
    private static Integer calculateDemographicScore(
        Lead lead, 
        List<ACME_Scoring_Criteria__mdt> scoringCriteria
    ) {
        Integer demographicScore = 0;
        
        for (ACME_Scoring_Criteria__mdt criteria : scoringCriteria) {
            if (criteria.Score_Type__c == 'Demographic') {
                Object fieldValue = lead.get(criteria.Criteria_Field__c);
                
                if (fieldValue != null) {
                    if (fieldValue instanceof String) {
                        String strValue = (String)fieldValue;
                        if (strValue == criteria.Minimum_Value__c) {
                            demographicScore += criteria.Score_Points__c.intValue();
                        }
                    }
                }
            }
        }
        
        return Math.min(demographicScore, 100);
    }
}