/**
 * Service class for lead scoring calculations
 * Implements core lead scoring logic with security and modularity
 */
public with sharing class ACMELeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographic factors
     * @param leadId The ID of the lead to score
     * @return Calculated lead score
     */
    public static Decimal calculateLeadScore(Id leadId) {
        // Verify object and field-level security
        if (!Schema.sObjectType.Lead.isAccessible() || 
            !Schema.sObjectType.Lead.fields.ACME_Engagement_Score__c.isAccessible() ||
            !Schema.sObjectType.Lead.fields.ACME_Demographics_Score__c.isAccessible()) {
            throw new System.NoAccessException('Insufficient object/field access');
        }

        // Retrieve lead with necessary fields
        Lead leadRecord = [
            SELECT Id, 
                   ACME_Engagement_Score__c, 
                   ACME_Demographics_Score__c 
            FROM Lead 
            WHERE Id = :leadId 
            WITH SECURITY_ENFORCED 
            LIMIT 1
        ];

        // Retrieve scoring weights from custom metadata
        ACME_Lead_Scoring_Criteria__mdt scoringCriteria = [
            SELECT Engagement_Weight__c, Demographics_Weight__c 
            FROM ACME_Lead_Scoring_Criteria__mdt 
            WHERE DeveloperName = 'Default_Scoring_Rules' 
            LIMIT 1
        ];

        // Calculate weighted score
        Decimal engagementScore = leadRecord.ACME_Engagement_Score__c != null 
            ? leadRecord.ACME_Engagement_Score__c : 0;
        Decimal demographicsScore = leadRecord.ACME_Demographics_Score__c != null 
            ? leadRecord.ACME_Demographics_Score__c : 0;

        Decimal finalScore = (
            (engagementScore * scoringCriteria.Engagement_Weight__c) + 
            (demographicsScore * scoringCriteria.Demographics_Weight__c)
        );

        // Ensure score is between 0-100
        return Math.min(Math.max(finalScore, 0), 100);
    }

    /**
     * Update lead score and timestamp
     * @param leadId The ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Decimal score) {
        // Verify update permissions
        if (!Schema.sObjectType.Lead.isUpdateable()) {
            throw new System.NoAccessException('Insufficient update access');
        }

        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Scored_Timestamp__c = System.now()
        );

        // Perform update with security check
        try {
            update as system leadToUpdate;
        } catch (Exception e) {
            // Log error or rethrow
            throw new AuraHandledException('Error updating lead score: ' + e.getMessage());
        }
    }
}