/**
 * Service class for calculating and updating lead scores
 */
public with sharing class ACMELeadScoringService {
    private static final Integer MAX_SCORE = 100;
    private static final Integer ENGAGEMENT_MAX = 50;
    private static final Integer DEMOGRAPHIC_MAX = 50;

    private ACMELeadScoringSelector leadSelector;

    public ACMELeadScoringService() {
        this.leadSelector = new ACMELeadScoringSelector();
    }

    /**
     * Calculate lead score for given lead records
     * @param leadIds Set of lead record ids to score
     * @return Map of lead id to calculated score
     */
    public Map<Id, Decimal> calculateLeadScores(Set<Id> leadIds) {
        Map<Id, Decimal> leadScores = new Map<Id, Decimal>();
        
        List<Lead> leads = leadSelector.getLeadsForScoring(leadIds);
        
        for (Lead lead : leads) {
            Decimal engagementPoints = calculateEngagementPoints(lead);
            Decimal demographicPoints = calculateDemographicPoints(lead);
            
            Decimal totalScore = Math.min(engagementPoints + demographicPoints, MAX_SCORE);
            
            leadScores.put(lead.Id, totalScore);
        }
        
        return leadScores;
    }

    private Decimal calculateEngagementPoints(Lead lead) {
        // Sample engagement scoring logic
        Decimal points = 0;
        
        if (lead.ACME_Engagement_Points__c != null) {
            points = lead.ACME_Engagement_Points__c;
        }
        
        return Math.min(points, ENGAGEMENT_MAX);
    }

    private Decimal calculateDemographicPoints(Lead lead) {
        // Sample demographic scoring logic
        Decimal points = 0;
        
        if (lead.NumberOfEmployees != null) {
            points += lead.NumberOfEmployees >= 1000 ? 20 : 
                      lead.NumberOfEmployees >= 100 ? 10 : 5;
        }
        
        if (lead.Industry != null) {
            points += lead.Industry == 'Technology' ? 15 : 
                      lead.Industry == 'Finance' ? 10 : 5;
        }
        
        return Math.min(points, DEMOGRAPHIC_MAX);
    }

    /**
     * Update lead scores in bulk
     * @param leadScores Map of lead id to calculated score
     */
    public void updateLeadScores(Map<Id, Decimal> leadScores) {
        if (leadScores == null || leadScores.isEmpty()) {
            return;
        }

        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Id leadId : leadScores.keySet()) {
            Lead leadToUpdate = new Lead(
                Id = leadId,
                ACME_Lead_Score__c = leadScores.get(leadId),
                ACME_Score_Last_Updated__c = System.now()
            );
            leadsToUpdate.add(leadToUpdate);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            Database.update(leadsToUpdate, false);
        }
    }
}