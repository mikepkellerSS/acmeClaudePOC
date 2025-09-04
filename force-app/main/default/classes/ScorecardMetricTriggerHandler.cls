// ScorecardMetric__c
public with sharing class ScorecardMetricTriggerHandler {
    public static void updateLeadScore(List<ScorecardMetric__c> newMetrics, Map<Id, ScorecardMetric__c> oldMetricsMap) {
        Set<Id> leadIds = new Set<Id>();
        for (ScorecardMetric__c metric : newMetrics) {
            if (oldMetricsMap == null || metric.Value__c != oldMetricsMap.get(metric.Id).Value__c) {
                leadIds.add(metric.Lead__c);
            }
        }

        if (!leadIds.isEmpty()) {
            updateLeadScores(leadIds);
        }
    }

    private static void updateLeadScores(Set<Id> leadIds) {
        List<Lead> leadsToUpdate = [
            SELECT Id, LeadScore__c
            FROM Lead
            WHERE Id IN :leadIds
        ];

        for (Lead lead : leadsToUpdate) {
            lead.LeadScore__c = calculateLeadScore(lead);
        }

        update leadsToUpdate;
    }

    private static Integer calculateLeadScore(Lead lead) {
        Integer score = 0;

        // Add logic to calculate lead score based on engagement and demographics
        if (lead.Email != null && lead.Email.endsWith('@acme.com')) {
            score += 20;
        }
        if (lead.NumberOfEmployees__c > 50) {
            score += 10;
        }
        if (lead.ConvertedOpportunityId != null) {
            score += 30;
        }

        return score;
    }
}