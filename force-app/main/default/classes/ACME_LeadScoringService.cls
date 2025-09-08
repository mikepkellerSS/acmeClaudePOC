/**
 * @description Lead scoring service for calculating and updating lead scores
 * @author Studio Science
 * @date 2025-09-08
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead score based on multiple criteria
     * @param lead Input lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead lead) {
        // Validate input
        if (lead == null) {
            return 0;
        }

        Integer score = 0;
        
        // Industry scoring
        if (String.isNotBlank(lead.Industry)) {
            score += getIndustryWeight(lead.Industry);
        }
        
        // Company size scoring
        if (lead.NumberOfEmployees != null) {
            score += getCompanySizeScore(lead.NumberOfEmployees);
        }
        
        // Email domain scoring
        if (String.isNotBlank(lead.Email)) {
            score += getEmailDomainScore(lead.Email);
        }
        
        // Lead source scoring
        if (String.isNotBlank(lead.LeadSource)) {
            score += getLeadSourceWeight(lead.LeadSource);
        }
        
        // Ensure score is between 0 and 100
        return Math.min(Math.max(score, 0), 100);
    }
    
    /**
     * Get weight for industry
     * @param industry Industry name
     * @return Integer industry weight
     */
    private static Integer getIndustryWeight(String industry) {
        Map<String, Integer> industryWeights = new Map<String, Integer>{
            'Technology' => 25,
            'Finance' => 20,
            'Healthcare' => 15,
            'Retail' => 10,
            'Other' => 5
        };
        
        return industryWeights.containsKey(industry) 
            ? industryWeights.get(industry) 
            : 5;
    }
    
    /**
     * Get score based on company size
     * @param employees Number of employees
     * @return Integer company size score
     */
    private static Integer getCompanySizeScore(Integer employees) {
        if (employees >= 1000) return 20;
        if (employees >= 500) return 15;
        if (employees >= 100) return 10;
        if (employees >= 50) return 5;
        return 0;
    }
    
    /**
     * Get score based on email domain
     * @param email Email address
     * @return Integer email domain score
     */
    private static Integer getEmailDomainScore(String email) {
        if (String.isBlank(email)) return 0;
        
        String domain = email.substringAfter('@');
        Set<String> premiumDomains = new Set<String>{
            'gmail.com', 'yahoo.com', 'hotmail.com'
        };
        
        Set<String> corporateDomains = new Set<String>{
            'microsoft.com', 'google.com', 'salesforce.com'
        };
        
        if (corporateDomains.contains(domain)) return 15;
        if (!premiumDomains.contains(domain)) return 10;
        
        return 0;
    }
    
    /**
     * Get weight for lead source
     * @param source Lead source
     * @return Integer lead source weight
     */
    private static Integer getLeadSourceWeight(String source) {
        Map<String, Integer> sourceWeights = new Map<String, Integer>{
            'Web' => 20,
            'Referral' => 15,
            'Partner' => 10,
            'Trade Show' => 5,
            'Other' => 0
        };
        
        return sourceWeights.containsKey(source) 
            ? sourceWeights.get(source) 
            : 0;
    }
    
    /**
     * Update lead score for multiple leads
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return;
        }
        
        for (Lead lead : leads) {
            lead.ACME_Lead_Score__c = calculateLeadScore(lead);
        }
        
        // Perform update with system context
        if (Schema.sObjectType.Lead.isUpdateable()) {
            update leads;
        }
    }
}