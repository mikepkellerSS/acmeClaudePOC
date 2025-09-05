/**
 * @description Lead scoring calculation service
 * @author Studio Science
 * @date 2025-09-05
 */
public with sharing class ACME_LeadScoring_Service {
    
    /**
     * Calculate lead score based on configured metrics
     * @param leadRecord Lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        // Validate input
        if (leadRecord == null) {
            return 0;
        }

        // Retrieve active scoring models
        List<ACME_LeadScoreModel__c> scoringModels = [
            SELECT Metric_Name__c, Weight__c 
            FROM ACME_LeadScoreModel__c 
            WHERE Active__c = true
        ];

        Integer totalScore = 0;
        
        // Apply scoring rules
        for (ACME_LeadScoreModel__c model : scoringModels) {
            if (model.Metric_Name__c == 'Company Size') {
                totalScore += calculateCompanySizeScore(leadRecord, model.Weight__c);
            } else if (model.Metric_Name__c == 'Industry') {
                totalScore += calculateIndustryScore(leadRecord, model.Weight__c);
            }
            // Add more scoring metrics as needed
        }

        // Ensure score is between 0-100
        return Math.min(Math.max(totalScore, 0), 100);
    }

    /**
     * Calculate score based on company size
     * @param lead Lead record
     * @param weight Scoring weight
     * @return Integer subscore
     */
    private static Integer calculateCompanySizeScore(Lead lead, Decimal weight) {
        if (lead.NumberOfEmployees == null) {
            return 0;
        }

        Integer employeeCount = lead.NumberOfEmployees;
        Integer score = 0;

        if (employeeCount >= 1000) {
            score = 100;
        } else if (employeeCount >= 500) {
            score = 75;
        } else if (employeeCount >= 100) {
            score = 50;
        } else if (employeeCount >= 10) {
            score = 25;
        }

        return Integer.valueOf(score * (weight / 100));
    }

    /**
     * Calculate score based on industry
     * @param lead Lead record
     * @param weight Scoring weight
     * @return Integer subscore
     */
    private static Integer calculateIndustryScore(Lead lead, Decimal weight) {
        Set<String> highValueIndustries = new Set<String>{
            'Technology', 'Finance', 'Healthcare'
        };

        if (String.isBlank(lead.Industry)) {
            return 0;
        }

        Integer score = highValueIndustries.contains(lead.Industry) ? 100 : 0;
        return Integer.valueOf(score * (weight / 100));
    }
}