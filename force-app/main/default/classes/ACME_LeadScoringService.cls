/**
 * Service class for calculating and managing lead scores
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score for a specific lead
     * @param leadId The ID of the lead to score
     * @return The calculated lead score
     */
    public static Decimal calculateLeadScore(Id leadId) {
        // Validate input
        if (leadId == null) {
            throw new IllegalArgumentException('Lead ID cannot be null');
        }

        // Retrieve lead with necessary details
        Lead leadRecord = retrieveLead(leadId);
        
        // Calculate scores for different criteria
        Decimal engagementPoints = calculateEngagementPoints(leadRecord);
        Decimal demographicPoints = calculateDemographicPoints(leadRecord);
        
        // Total score calculation
        Decimal totalScore = engagementPoints + demographicPoints;
        
        // Create or update lead score record
        upsertLeadScoreRecord(leadId, totalScore, engagementPoints, demographicPoints);
        
        return totalScore;
    }
    
    /**
     * Retrieve lead record with necessary details
     * @param leadId The ID of the lead to retrieve
     * @return The lead record
     */
    private static Lead retrieveLead(Id leadId) {
        // Implement secure query with FLS checks
        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new System.NoAccessException('No access to Lead object');
        }
        
        return [
            SELECT Id, Email, Company, Title, 
                   NumberOfEmployees, LeadSource, 
                   (SELECT Id FROM Interactions__r)
            FROM Lead 
            WHERE Id = :leadId 
            LIMIT 1
        ];
    }
    
    /**
     * Calculate engagement points based on lead interactions
     * @param lead The lead record
     * @return Engagement points
     */
    private static Decimal calculateEngagementPoints(Lead lead) {
        Decimal engagementPoints = 0;
        
        // Email engagement
        if (String.isNotBlank(lead.Email)) {
            engagementPoints += 10;
        }
        
        // Interaction points
        if (lead.Interactions__r != null && !lead.Interactions__r.isEmpty()) {
            engagementPoints += Math.min(lead.Interactions__r.size() * 5, 30);
        }
        
        return engagementPoints;
    }
    
    /**
     * Calculate demographic points based on lead attributes
     * @param lead The lead record
     * @return Demographic points
     */
    private static Decimal calculateDemographicPoints(Lead lead) {
        Decimal demographicPoints = 0;
        
        // Company size points
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees > 1000) {
                demographicPoints += 20;
            } else if (lead.NumberOfEmployees > 100) {
                demographicPoints += 10;
            }
        }
        
        // Job title points
        if (String.isNotBlank(lead.Title)) {
            List<String> seniorTitles = new List<String>{'CEO', 'CTO', 'CFO', 'Director', 'VP'};
            for (String title : seniorTitles) {
                if (lead.Title.containsIgnoreCase(title)) {
                    demographicPoints += 15;
                    break;
                }
            }
        }
        
        return demographicPoints;
    }
    
    /**
     * Upsert lead score record
     * @param leadId The lead ID
     * @param totalScore Total calculated score
     * @param engagementPoints Engagement points
     * @param demographicPoints Demographic points
     */
    private static void upsertLeadScoreRecord(Id leadId, Decimal totalScore, 
                                              Decimal engagementPoints, 
                                              Decimal demographicPoints) {
        // Implement secure DML with FLS checks
        if (!Schema.sObjectType.ACME_LeadScore__c.isCreateable() || 
            !Schema.sObjectType.ACME_LeadScore__c.isUpdateable()) {
            throw new System.NoAccessException('No access to create/update Lead Score');
        }
        
        ACME_LeadScore__c leadScore = new ACME_LeadScore__c(
            Lead__c = leadId,
            Score__c = totalScore,
            LastCalculated__c = System.now(),
            EngagementPoints__c = engagementPoints,
            DemographicPoints__c = demographicPoints
        );
        
        // Upsert based on Lead lookup
        upsert leadScore Lead__c;
    }
}