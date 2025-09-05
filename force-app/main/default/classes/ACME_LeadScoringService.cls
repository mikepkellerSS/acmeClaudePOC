public with sharing class ACME_LeadScoringService {
    public static Integer calculateLeadScore(Lead leadRecord) {
        Integer score = 0;
        
        // Engagement Metrics
        if (leadRecord.NumberOfEmployees != null) {
            score += calculateCompanySizeScore(leadRecord.NumberOfEmployees);
        }
        
        // Industry Scoring
        if (String.isNotBlank(leadRecord.Industry)) {
            score += calculateIndustryScore(leadRecord.Industry);
        }
        
        // Previous Interactions
        score += calculateInteractionScore(leadRecord);
        
        // Ensure score is between 0-100
        return Math.min(Math.max(score, 0), 100);
    }
    
    private static Integer calculateCompanySizeScore(Integer employees) {
        if (employees >= 1000) return 30;
        if (employees >= 500) return 20;
        if (employees >= 100) return 10;
        return 5;
    }
    
    private static Integer calculateIndustryScore(String industry) {
        Map<String, Integer> industryScores = new Map<String, Integer>{
            'Technology' => 30,
            'Finance' => 25,
            'Healthcare' => 20,
            'Manufacturing' => 15,
            'Retail' => 10
        };
        
        return industryScores.containsKey(industry) 
            ? industryScores.get(industry) 
            : 5;
    }
    
    private static Integer calculateInteractionScore(Lead leadRecord) {
        Integer interactionScore = 0;
        
        // Example interaction scoring logic
        if (leadRecord.HasOptedOutOfEmail == false) interactionScore += 10;
        if (leadRecord.Email != null) interactionScore += 15;
        
        return interactionScore;
    }
}