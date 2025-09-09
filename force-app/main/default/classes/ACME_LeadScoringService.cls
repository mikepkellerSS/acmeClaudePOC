/**
 * @description Lead scoring service for automated lead prioritization
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_LeadScoringService {
    
    // Constants for scoring weights
    private static final Integer DEMOGRAPHIC_WEIGHT = 40;
    private static final Integer ENGAGEMENT_WEIGHT = 60;
    
    /**
     * Calculate comprehensive lead score based on multiple factors
     * @param leadRecord Lead record to be scored
     * @return Calculated lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        if (leadRecord == null) {
            return 0;
        }
        
        Integer demographicScore = calculateDemographicScore(leadRecord);
        Integer engagementScore = calculateEngagementScore(leadRecord);
        
        Integer totalScore = calculateWeightedScore(demographicScore, engagementScore);
        
        return Math.min(Math.max(totalScore, 0), 100);
    }
    
    /**
     * Calculate demographic score based on company attributes
     * @param leadRecord Lead record to evaluate
     * @return Demographic score component
     */
    private static Integer calculateDemographicScore(Lead leadRecord) {
        Integer score = 0;
        
        // Company size scoring
        if (leadRecord.NumberOfEmployees != null) {
            if (leadRecord.NumberOfEmployees >= 500) {
                score += 40;
            } else if (leadRecord.NumberOfEmployees >= 100) {
                score += 20;
            } else if (leadRecord.NumberOfEmployees >= 50) {
                score += 10;
            }
        }
        
        // Industry scoring
        if (String.isNotBlank(leadRecord.Industry)) {
            switch on leadRecord.Industry.toLowerCase() {
                when 'technology', 'finance', 'healthcare' {
                    score += 30;
                }
                when 'manufacturing', 'education' {
                    score += 15;
                }
            }
        }
        
        return Math.min(score, 100);
    }
    
    /**
     * Calculate engagement score based on interaction metrics
     * @param leadRecord Lead record to evaluate
     * @return Engagement score component
     */
    private static Integer calculateEngagementScore(Lead leadRecord) {
        Integer score = 0;
        
        // Website visits scoring
        if (leadRecord.ACME_Website_Visits__c != null) {
            Decimal visits = leadRecord.ACME_Website_Visits__c;
            if (visits >= 10) {
                score += 40;
            } else if (visits >= 5) {
                score += 20;
            } else if (visits >= 1) {
                score += 10;
            }
        }
        
        // Email interactions scoring
        if (leadRecord.ACME_Email_Interactions__c != null) {
            Decimal interactions = leadRecord.ACME_Email_Interactions__c;
            if (interactions >= 5) {
                score += 30;
            } else if (interactions >= 2) {
                score += 15;
            }
        }
        
        // Content download scoring
        if (leadRecord.ACME_Content_Downloads__c != null) {
            Decimal downloads = leadRecord.ACME_Content_Downloads__c;
            if (downloads >= 3) {
                score += 30;
            } else if (downloads >= 1) {
                score += 15;
            }
        }
        
        return Math.min(score, 100);
    }
    
    /**
     * Calculate weighted score combining demographic and engagement scores
     * @param demographicScore Demographic score component
     * @param engagementScore Engagement score component
     * @return Weighted total score
     */
    private static Integer calculateWeightedScore(Integer demographicScore, Integer engagementScore) {
        Decimal weightedScore = (
            (demographicScore * DEMOGRAPHIC_WEIGHT / 100.0) + 
            (engagementScore * ENGAGEMENT_WEIGHT / 100.0)
        ) * 100;
        
        return weightedScore.intValue();
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
            
            // Perform update with system context to bypass sharing rules
            Database.update(Security.stripInaccessible(
                AccessType.UPDATABLE, 
                new List<Lead>{ leadToUpdate }
            ).getRecords());
        } catch (Exception e) {
            // Log error for tracking
            System.debug(LoggingLevel.ERROR, 
                'Lead Score Update Error: ' + e.getMessage());
        }
    }
}