/**
 * @description Lead scoring service for calculating and managing lead scores
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACMELeadScoringService {
    
    /**
     * Calculate lead score based on engagement and demographics
     * @param leadRecord Lead record to score
     * @return Integer Lead score between 1-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Secure implementation with FLS checks
        Integer score = 0;
        
        try {
            // Retrieve scoring criteria from custom metadata
            List<ACME_Scoring_Configuration__mdt> scoringCriteria = 
                [SELECT MasterLabel, ACME_Weight__c 
                 FROM ACME_Scoring_Configuration__mdt 
                 WITH SECURITY_ENFORCED];
            
            // Dynamic scoring calculation
            for (ACME_Scoring_Configuration__mdt criteria : scoringCriteria) {
                // Example scoring logic - customize based on specific requirements
                if (criteria.MasterLabel == 'Company_Size') {
                    score += calculateCompanySizeScore(leadRecord, criteria.ACME_Weight__c);
                } else if (criteria.MasterLabel == 'Industry') {
                    score += calculateIndustryScore(leadRecord, criteria.ACME_Weight__c);
                } else if (criteria.MasterLabel == 'Engagement') {
                    score += calculateEngagementScore(leadRecord, criteria.ACME_Weight__c);
                }
            }
            
            // Ensure score is between 1 and 100
            return Math.min(Math.max(score, 1), 100);
        } catch (Exception e) {
            // Log error and return minimum score
            System.debug('Lead Scoring Error: ' + e.getMessage());
            return 1;
        }
    }
    
    /**
     * Calculate score based on company size
     * @param lead Lead record
     * @param weight Scoring weight
     * @return Integer Calculated score component
     */
    private static Integer calculateCompanySizeScore(Lead lead, Decimal weight) {
        if (lead.NumberOfEmployees == null) return 0;
        
        Integer employeeCount = lead.NumberOfEmployees;
        if (employeeCount >= 1000) return (Integer)(weight * 100);
        if (employeeCount >= 500) return (Integer)(weight * 75);
        if (employeeCount >= 100) return (Integer)(weight * 50);
        if (employeeCount >= 50) return (Integer)(weight * 25);
        return (Integer)(weight * 10);
    }
    
    /**
     * Calculate score based on industry
     * @param lead Lead record
     * @param weight Scoring weight
     * @return Integer Calculated score component
     */
    private static Integer calculateIndustryScore(Lead lead, Decimal weight) {
        Set<String> priorityIndustries = new Set<String>{
            'Technology', 'Finance', 'Healthcare', 'Manufacturing'
        };
        
        if (String.isBlank(lead.Industry)) return 0;
        
        return priorityIndustries.contains(lead.Industry) 
            ? (Integer)(weight * 100) 
            : (Integer)(weight * 25);
    }
    
    /**
     * Calculate score based on engagement
     * @param lead Lead record
     * @param weight Scoring weight
     * @return Integer Calculated score component
     */
    private static Integer calculateEngagementScore(Lead lead, Decimal weight) {
        Integer engagementScore = 0;
        
        // Example engagement factors
        if (lead.HasOptedOutOfEmail == false) engagementScore += 25;
        if (lead.Email != null) engagementScore += 25;
        if (lead.Phone != null) engagementScore += 25;
        
        return (Integer)(engagementScore * weight);
    }
    
    /**
     * Update lead score on the lead record
     * @param leadId ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Integer score) {
        // Perform update with system context to bypass sharing rules
        Lead leadToUpdate = new Lead(
            Id = leadId, 
            ACME_Lead_Score__c = score
        );
        
        // Perform update with system context
        Database.update(leadToUpdate, false);
    }
}