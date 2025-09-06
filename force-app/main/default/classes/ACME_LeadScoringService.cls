/**
 * @description Lead Scoring Service for calculating and managing lead scores
 * @author Acme Corp Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographic criteria
     * @param leadRecord Lead record to be scored
     * @return Integer representing the lead score
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        try {
            // Validate input
            if (leadRecord == null) {
                return 0;
            }

            // Retrieve scoring criteria from custom metadata
            List<ACME_Lead_Scoring_Criteria__mdt> scoringRules = 
                [SELECT DeveloperName, Score_Value__c, Criteria_Field__c, Criteria_Operator__c, Criteria_Value__c 
                 FROM ACME_Lead_Scoring_Criteria__mdt 
                 WHERE Active__c = true];

            Integer totalScore = 0;
            
            // Apply scoring rules
            for (ACME_Lead_Scoring_Criteria__mdt rule : scoringRules) {
                if (meetsRule(leadRecord, rule)) {
                    totalScore += Integer.valueOf(rule.Score_Value__c);
                }
            }

            // Ensure score is within 0-100 range
            return Math.min(Math.max(totalScore, 0), 100);
        } catch (Exception e) {
            // Log error and return default score
            ACME_LeadScoringLogger.logError('Lead Scoring Error', e);
            return 0;
        }
    }

    /**
     * Check if lead meets a specific scoring rule
     * @param lead Lead record to evaluate
     * @param rule Scoring rule from custom metadata
     * @return Boolean indicating if rule is met
     */
    private static Boolean meetsRule(Lead lead, ACME_Lead_Scoring_Criteria__mdt rule) {
        try {
            Object fieldValue = lead.get(rule.Criteria_Field__c);
            String criteriaValue = rule.Criteria_Value__c;
            String operator = rule.Criteria_Operator__c;

            if (fieldValue == null || criteriaValue == null || operator == null) {
                return false;
            }

            switch on operator {
                when 'EQUALS' {
                    return String.valueOf(fieldValue) == criteriaValue;
                }
                when 'GREATER_THAN' {
                    return Decimal.valueOf(String.valueOf(fieldValue)) > Decimal.valueOf(criteriaValue);
                }
                when 'LESS_THAN' {
                    return Decimal.valueOf(String.valueOf(fieldValue)) < Decimal.valueOf(criteriaValue);
                }
                when else {
                    return false;
                }
            }
        } catch (Exception e) {
            ACME_LeadScoringLogger.logError('Rule Evaluation Error', e);
            return false;
        }
    }

    /**
     * Update lead score and last scored date
     * @param leadId ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Integer score) {
        try {
            Lead leadToUpdate = new Lead(
                Id = leadId,
                ACME_Lead_Score__c = score,
                ACME_Last_Scored_Date__c = System.now()
            );

            // Perform update with system context
            Database.update(leadToUpdate, false);
        } catch (Exception e) {
            ACME_LeadScoringLogger.logError('Lead Score Update Error', e);
        }
    }
}