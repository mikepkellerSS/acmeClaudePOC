/**
 * Service class for calculating lead scores based on engagement and demographic criteria
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographic points
     * @param leadId The ID of the lead to score
     * @return The calculated lead score
     */
    public static Decimal calculateLeadScore(Id leadId) {
        if (leadId == null) {
            return 0;
        }

        // Retrieve lead details
        Lead leadRecord = retrieveLeadDetails(leadId);
        
        // Calculate engagement points
        Decimal engagementPoints = calculateEngagementPoints(leadRecord);
        
        // Calculate demographic points
        Decimal demographicPoints = calculateDemographicPoints(leadRecord);
        
        // Combine points and normalize score
        Decimal totalScore = engagementPoints + demographicPoints;
        Decimal normalizedScore = Math.min(Math.max(totalScore, 0), 100);
        
        // Create or update lead scoring metric
        upsertLeadScoringMetric(leadId, normalizedScore, engagementPoints, demographicPoints);
        
        return normalizedScore;
    }
    
    /**
     * Retrieve lead details for scoring
     * @param leadId The ID of the lead to retrieve
     * @return Lead record with relevant details
     */
    private static Lead retrieveLeadDetails(Id leadId) {
        // Secure query with FLS check
        if (!Schema.sObjectType.Lead.isAccessible()) {
            throw new System.NoAccessException('No access to Lead object');
        }
        
        return [
            SELECT Id, Email, Company, Industry, NumberOfEmployees, 
                   LeadSource, Status, CreatedDate
            FROM Lead 
            WHERE Id = :leadId 
            LIMIT 1
        ];
    }
    
    /**
     * Calculate engagement points based on lead interactions
     * @param lead The lead record to evaluate
     * @return Engagement points
     */
    private static Decimal calculateEngagementPoints(Lead lead) {
        Decimal engagementPoints = 0;
        
        // Sample engagement scoring logic
        if (String.isNotBlank(lead.Email)) {
            engagementPoints += 10; // Email provided
        }
        
        if (lead.LeadSource == 'Web') {
            engagementPoints += 15; // Web lead
        }
        
        // Additional engagement scoring can be added here
        
        return engagementPoints;
    }
    
    /**
     * Calculate demographic points based on lead attributes
     * @param lead The lead record to evaluate
     * @return Demographic points
     */
    private static Decimal calculateDemographicPoints(Lead lead) {
        Decimal demographicPoints = 0;
        
        // Sample demographic scoring logic
        if (lead.NumberOfEmployees > 100) {
            demographicPoints += 20; // Enterprise company
        }
        
        if (lead.Industry == 'Technology') {
            demographicPoints += 15; // Target industry
        }
        
        // Additional demographic scoring can be added here
        
        return demographicPoints;
    }
    
    /**
     * Upsert lead scoring metric record
     * @param leadId The ID of the lead
     * @param score The calculated score
     * @param engagementPoints Engagement points
     * @param demographicPoints Demographic points
     */
    private static void upsertLeadScoringMetric(
        Id leadId, 
        Decimal score, 
        Decimal engagementPoints, 
        Decimal demographicPoints
    ) {
        // Secure DML with FLS checks
        if (!Schema.sObjectType.ACME_LeadScoringMetric__c.isCreateable() || 
            !Schema.sObjectType.ACME_LeadScoringMetric__c.isUpdateable()) {
            throw new System.NoAccessException('No access to Lead Scoring Metric');
        }
        
        ACME_LeadScoringMetric__c scoringMetric = new ACME_LeadScoringMetric__c(
            LeadId__c = leadId,
            Score__c = score,
            LastCalculatedDate__c = System.now(),
            EngagementPoints__c = engagementPoints,
            DemographicPoints__c = demographicPoints
        );
        
        // Upsert based on Lead lookup
        upsert scoringMetric LeadId__c;
    }
}