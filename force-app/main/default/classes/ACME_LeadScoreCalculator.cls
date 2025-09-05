public with sharing class ACME_LeadScoreCalculator {
    public static Integer calculateLeadScore(Lead leadRecord) {
        Integer totalScore = 0;

        // Company Size Scoring
        totalScore += calculateCompanySizeScore(leadRecord);

        // Engagement Scoring
        totalScore += calculateEngagementScore(leadRecord);

        // Industry Scoring
        totalScore += calculateIndustryScore(leadRecord);

        // Ensure score is between 0-100
        return Math.min(Math.max(totalScore, 0), 100);
    }

    private static Integer calculateCompanySizeScore(Lead lead) {
        // Example scoring logic for company size
        if (lead.NumberOfEmployees == null) return 0;
        
        Integer companySize = lead.NumberOfEmployees;
        if (companySize < 50) return 10;
        if (companySize < 200) return 20;
        if (companySize < 500) return 30;
        return 40;
    }

    private static Integer calculateEngagementScore(Lead lead) {
        // Example engagement scoring
        Integer engagementScore = 0;
        
        if (lead.HasOptedOutOfEmail == false) engagementScore += 10;
        if (lead.EmailBouncedReason == null) engagementScore += 15;
        
        return engagementScore;
    }

    private static Integer calculateIndustryScore(Lead lead) {
        // Example industry scoring
        Map<String, Integer> industryScores = new Map<String, Integer>{
            'Technology' => 40,
            'Finance' => 35,
            'Healthcare' => 30,
            'Retail' => 25
        };

        return industryScores.containsKey(lead.Industry) 
            ? industryScores.get(lead.Industry) 
            : 20;
    }
}