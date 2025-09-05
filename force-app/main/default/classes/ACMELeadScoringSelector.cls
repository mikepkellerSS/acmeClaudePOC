/**
 * Selector class for Lead Scoring queries with sharing enforcement
 */
public with sharing class ACMELeadScoringSelector {
    
    /**
     * Retrieve leads for scoring with key fields
     * @param leadIds Set of lead record ids to query
     * @return List of Lead records with scoring-relevant fields
     */
    public List<Lead> getLeadsForScoring(Set<Id> leadIds) {
        if (leadIds == null || leadIds.isEmpty()) {
            return new List<Lead>();
        }

        return [
            SELECT Id, 
                   Company, 
                   Industry, 
                   NumberOfEmployees, 
                   Title, 
                   Country,
                   ACME_Engagement_Points__c,
                   ACME_Demographic_Points__c
            FROM Lead 
            WHERE Id IN :leadIds 
            WITH SECURITY_ENFORCED
            LIMIT 10000
        ];
    }
}