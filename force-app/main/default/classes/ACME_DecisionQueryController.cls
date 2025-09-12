@AuraEnabled
public with sharing class ACME_DecisionQueryController {
    @AuraEnabled(cacheable=true)
    public static String processNaturalLanguageQuery(String query) {
        try {
            // Validate input
            if (String.isBlank(query)) {
                return 'Please provide a valid query.';
            }
            
            // Delegate to AI Decision Query Service
            return ACME_AIDecisionQueryService.queryDecisions(query);
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_DecisionQueryController', 'processNaturalLanguageQuery', e);
            return 'Error processing query: ' + e.getMessage();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ACME_SupremeCourtDecision__c> getRecentDecisions() {
        return [
            SELECT Id, CaseNumber__c, DecisionDate__c, StatutesReferenced__c 
            FROM ACME_SupremeCourtDecision__c 
            ORDER BY DecisionDate__c DESC 
            LIMIT 5
        ];
    }
}