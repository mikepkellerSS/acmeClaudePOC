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
        // Validate input
        if (leadRecord == null) {
            return 0;
        }

        // Calculate engagement and demographic points
        Integer engagementScore = calculateEngagementPoints(leadRecord);
        Integer demographicScore = calculateDemographicPoints(leadRecord);
        
        // Weighted scoring model
        return Math.min(100, Math.max(0, 
            Integer.valueOf((engagementScore * 0.6) + (demographicScore * 0.4))
        ));
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
        if (leadRecord.get('Number_of_Website_Visits__c') != null) {
            points += Math.min(
                Integer.valueOf(leadRecord.get('Number_of_Website_Visits__c')) * 2, 
                20
            );
        }

        // Social media engagement
        if (leadRecord.get('Social_Media_Interactions__c') != null) {
            points += Math.min(
                Integer.valueOf(leadRecord.get('Social_Media_Interactions__c')) * 3, 
                15
            );
        }

        return points;
    }

    /**
     * Calculate demographic points based on lead profile
     * @param leadRecord Lead record to evaluate
     * @return Integer demographic points
     */
    private static Integer calculateDemographicPoints(Lead leadRecord) {
        Integer points = 0;

        // Company size points
        if (leadRecord.get('Number_of_Employees__c') != null) {
            Integer employeeCount = Integer.valueOf(leadRecord.get('Number_of_Employees__c'));
            if (employeeCount >= 500) {
                points += 20;
            } else if (employeeCount >= 100) {
                points += 10;
            }
        }

        // Industry points
        if (String.isNotBlank(leadRecord.Industry)) {
            points += 10;
        }

        // Job title relevance
        if (String.isNotBlank(leadRecord.Title)) {
            String lowercaseTitle = leadRecord.Title.toLowerCase();
            if (lowercaseTitle.contains('director') || 
                lowercaseTitle.contains('manager') || 
                lowercaseTitle.contains('executive')) {
                points += 15;
            }
        }

        return points;
    }

    /**
     * Update lead score and related fields
     * @param leadId ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Integer score) {
        // Perform security checks
        if (!Schema.sObjectType.Lead.isUpdateable()) {
            throw new SecurityException('Insufficient permissions to update Lead');
        }

        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Score_Calculation__c = System.now()
        );

        try {
            update leadToUpdate;
        } catch (Exception e) {
            // Log error
            System.debug(LoggingLevel.ERROR, 
                'Error updating lead score: ' + e.getMessage());
        }
    }
}