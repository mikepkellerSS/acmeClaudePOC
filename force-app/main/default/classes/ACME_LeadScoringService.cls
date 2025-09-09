/**
 * @description Lead Scoring Service for calculating and managing lead scores
 * @author ACME Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographic points
     * @param leadRecord Lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        if (leadRecord == null) {
            return 0;
        }

        Integer engagementPoints = calculateEngagementPoints(leadRecord);
        Integer demographicPoints = calculateDemographicPoints(leadRecord);
        
        return Math.min(100, Math.max(0, engagementPoints + demographicPoints));
    }

    /**
     * Calculate engagement points based on lead interactions
     * @param leadRecord Lead record to evaluate
     * @return Integer engagement points
     */
    private static Integer calculateEngagementPoints(Lead leadRecord) {
        Integer points = 0;

        // Email engagement
        if (String.isNotBlank(leadRecord.Email)) {
            points += 10;
        }

        // Web activity points
        if (leadRecord.Number_of_Website_Visits__c != null) {
            points += Math.min(leadRecord.Number_of_Website_Visits__c * 2, 20);
        }

        // Campaign response
        if (leadRecord.HasOptedOutOfEmail == false) {
            points += 15;
        }

        return points;
    }

    /**
     * Calculate demographic points based on lead attributes
     * @param leadRecord Lead record to evaluate
     * @return Integer demographic points
     */
    private static Integer calculateDemographicPoints(Lead leadRecord) {
        Integer points = 0;

        // Company size points
        if (leadRecord.NumberOfEmployees != null) {
            if (leadRecord.NumberOfEmployees >= 500) {
                points += 25;
            } else if (leadRecord.NumberOfEmployees >= 100) {
                points += 15;
            } else if (leadRecord.NumberOfEmployees >= 50) {
                points += 10;
            }
        }

        // Industry points
        if (String.isNotBlank(leadRecord.Industry)) {
            switch on leadRecord.Industry.toLowerCase() {
                when 'technology', 'finance', 'healthcare' {
                    points += 20;
                }
                when 'manufacturing', 'telecommunications' {
                    points += 15;
                }
            }
        }

        return points;
    }

    /**
     * Update lead score and last calculation timestamp
     * @param leadId ID of lead to update
     */
    public static void updateLeadScore(Id leadId) {
        if (leadId == null) {
            return;
        }

        Lead leadRecord = [
            SELECT Id, Email, NumberOfEmployees, Industry, 
                   Number_of_Website_Visits__c, HasOptedOutOfEmail
            FROM Lead 
            WHERE Id = :leadId 
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        Integer calculatedScore = calculateLeadScore(leadRecord);

        // Update lead with new score
        Lead updateLead = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = calculatedScore,
            ACME_Last_Score_Calculation__c = System.now()
        );

        // Perform update with FLS check
        if (Schema.sObjectType.Lead.isUpdateable()) {
            update updateLead;
        }
    }
}