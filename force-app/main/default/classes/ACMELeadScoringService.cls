/**
 * @description Service class for lead scoring calculations
 */
public with sharing class ACMELeadScoringService {
    
    /**
     * @description Calculates lead score based on engagement and demographic factors
     * @param leadRecord Lead record to score
     * @return Integer lead score between 0-100
     */
    public static Integer calculateLeadScore(Lead leadRecord) {
        if (leadRecord == null) {
            return 0;
        }

        Integer engagementScore = calculateEngagementScore(leadRecord);
        Integer demographicScore = calculateDemographicScore(leadRecord);
        
        return Math.min(100, Math.max(0, engagementScore + demographicScore));
    }

    /**
     * @description Calculates engagement score for a lead
     * @param leadRecord Lead record to evaluate
     * @return Integer engagement score
     */
    private static Integer calculateEngagementScore(Lead leadRecord) {
        Integer score = 0;

        // Email opens scoring
        if (leadRecord.Number_of_Email_Opens__c != null) {
            score += Math.min(20, (Integer)leadRecord.Number_of_Email_Opens__c * 2);
        }

        // Website visits scoring
        if (leadRecord.Website_Visits__c != null) {
            score += Math.min(15, (Integer)leadRecord.Website_Visits__c);
        }

        // Content downloads scoring
        if (leadRecord.Content_Downloads__c != null) {
            score += Math.min(15, (Integer)leadRecord.Content_Downloads__c * 3);
        }

        return score;
    }

    /**
     * @description Calculates demographic score for a lead
     * @param leadRecord Lead record to evaluate
     * @return Integer demographic score
     */
    private static Integer calculateDemographicScore(Lead leadRecord) {
        Integer score = 0;

        // Company size scoring
        if (leadRecord.Company_Size__c != null) {
            switch on leadRecord.Company_Size__c {
                when 'Enterprise' {
                    score += 20;
                }
                when 'Mid-Market' {
                    score += 15;
                }
                when 'Small Business' {
                    score += 10;
                }
            }
        }

        // Industry scoring
        if (leadRecord.Industry != null) {
            List<String> targetIndustries = new List<String>{'Technology', 'Finance', 'Healthcare'};
            if (targetIndustries.contains(leadRecord.Industry)) {
                score += 15;
            }
        }

        // Job title scoring
        if (leadRecord.Title != null) {
            List<String> seniorTitles = new List<String>{'CEO', 'CTO', 'CFO', 'Director', 'VP'};
            for (String title : seniorTitles) {
                if (leadRecord.Title.containsIgnoreCase(title)) {
                    score += 10;
                    break;
                }
            }
        }

        // Geographic region scoring
        if (leadRecord.Country != null) {
            List<String> targetCountries = new List<String>{'United States', 'Canada', 'United Kingdom'};
            if (targetCountries.contains(leadRecord.Country)) {
                score += 5;
            }
        }

        return score;
    }

    /**
     * @description Updates lead score and timestamp
     * @param leads List of leads to update
     */
    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : leads) {
            Integer newScore = calculateLeadScore(lead);
            
            lead.ACME_Lead_Score__c = newScore;
            lead.ACME_Lead_Score_Last_Updated__c = System.now();
            
            leadsToUpdate.add(lead);
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}