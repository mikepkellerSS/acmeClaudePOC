public with sharing class ACMELeadScoringService {
    public static List<Lead> scoreLead(List<Lead> leads) {
        // Check if leads list is empty
        if (leads == null || leads.isEmpty()) {
            return leads;
        }

        // Retrieve active scoring configuration
        List<ACME_Scoring_Configuration__mdt> configs = 
            [SELECT Id 
             FROM ACME_Scoring_Configuration__mdt 
             WHERE IsActive__c = true 
             LIMIT 1];
        
        // If no active configuration, return leads without scoring
        if (configs.isEmpty()) {
            return leads;
        }
        
        // Score each lead
        for (Lead lead : leads) {
            lead.Score__c = calculateLeadScore(lead);
        }
        
        return leads;
    }
    
    private static Integer calculateLeadScore(Lead lead) {
        // Comprehensive scoring algorithm
        Integer score = 0;
        
        // Email scoring
        if (lead.Email != null) {
            score += 10;
            // Additional email validation scoring
            if (isValidEmailFormat(lead.Email)) {
                score += 5;
            }
        }
        
        // Phone scoring
        if (lead.Phone != null) {
            score += 5;
            // Additional phone validation scoring
            if (isValidPhoneNumber(lead.Phone)) {
                score += 3;
            }
        }
        
        // Company scoring
        if (lead.Company != null && !String.isBlank(lead.Company)) {
            score += 3;
        }
        
        // Limit score to a reasonable range
        return Math.min(Math.max(score, 0), 100);
    }
    
    // Basic email validation
    private static Boolean isValidEmailFormat(String email) {
        String emailRegex = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';
        return email != null && Pattern.matches(emailRegex, email);
    }
    
    // Basic phone number validation
    private static Boolean isValidPhoneNumber(String phone) {
        // Remove non-digit characters
        String digitsOnly = phone.replaceAll('\\D', '');
        return digitsOnly.length() >= 10;
    }
}