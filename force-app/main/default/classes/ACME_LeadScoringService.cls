/**
 * Lead Scoring Service for automated lead prioritization
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * Calculate lead scores for given leads
     * @param leads List of leads to score
     */
    public static void calculateLeadScores(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return;
        }

        List<ACME_Lead_Scoring_Rule__mdt> scoringRules = ACME_LeadScoringRule.getActiveScoringRules();
        
        for (Lead lead : leads) {
            Integer totalScore = calculateLeadScore(lead, scoringRules);
            updateLeadScore(lead, totalScore);
        }
    }

    /**
     * Calculate total score for a single lead
     * @param lead Lead to score
     * @param scoringRules Active scoring rules
     * @return Calculated lead score
     */
    private static Integer calculateLeadScore(Lead lead, List<ACME_Lead_Scoring_Rule__mdt> scoringRules) {
        Integer totalScore = 0;

        for (ACME_Lead_Scoring_Rule__mdt rule : scoringRules) {
            Integer ruleScore = ACME_LeadScoringRule.calculateRuleScore(lead, rule);
            totalScore += ruleScore;
        }

        return Math.min(100, Math.max(0, totalScore));
    }

    /**
     * Update lead score and timestamp
     * @param lead Lead to update
     * @param score Calculated score
     */
    private static void updateLeadScore(Lead lead, Integer score) {
        lead.ACME_Lead_Score__c = score;
        lead.ACME_Last_Score_Calculated__c = System.now();
    }

    /**
     * Queueable version for processing large number of leads
     */
    public class LeadScoringQueueable implements Queueable {
        private List<Lead> leadsToScore;

        public LeadScoringQueueable(List<Lead> leads) {
            this.leadsToScore = leads;
        }

        public void execute(QueueableContext context) {
            calculateLeadScores(leadsToScore);
            
            // Optional: Update leads if needed
            if (!leadsToScore.isEmpty()) {
                Database.update(leadsToScore, false);
            }
        }
    }
}