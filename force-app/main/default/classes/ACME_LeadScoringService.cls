public with sharing class ACME_LeadScoringService {
    public static Integer calculateLeadScore(Lead leadRecord) {
        if (leadRecord == null) {
            return 1;
        }

        Integer score = 0;
        
        List<ACME_LeadScoringCriteria__mdt> criteria = 
            [SELECT Field__c, Weight__c, ScoreType__c 
             FROM ACME_LeadScoringCriteria__mdt];
        
        for (ACME_LeadScoringCriteria__mdt criterion : criteria) {
            if (meetsCriterion(leadRecord, criterion)) {
                score += Integer.valueOf(criterion.Weight__c);
            }
        }
        
        return Math.min(Math.max(score, 1), 100);
    }

    private static Boolean meetsCriterion(Lead lead, ACME_LeadScoringCriteria__mdt criterion) {
        try {
            Object fieldValue = lead.get(criterion.Field__c);
            return fieldValue != null;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 
                'Error evaluating lead scoring criterion: ' + e.getMessage());
            return false;
        }
    }

    public static void updateLeadScores(List<Lead> leads) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead lead : leads) {
            Integer score = calculateLeadScore(lead);
            
            Lead updatedLead = new Lead(Id = lead.Id);
            updatedLead.ACME_LeadScore__c = score;
            updatedLead.ACME_LastScoredDate__c = System.now();
            
            leadsToUpdate.add(updatedLead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            SObjectAccessDecision securityDecision = Security.stripInaccessible(
                AccessType.UPDATABLE, leadsToUpdate
            );
            
            update securityDecision.getRecords();
        }
    }
}