/**
 * Selector class for retrieving ACME_CalculationHistory__c records
 * Follows Selector Pattern for efficient data retrieval
 */
public with sharing class ACME__CalculationHistorySelector {
    
    /**
     * Retrieve calculation history records by ID
     * @param calculationIds Set of calculation history record IDs
     * @return List of ACME_CalculationHistory__c records
     */
    public static List<ACME_CalculationHistory__c> selectByIds(Set<Id> calculationIds) {
        return [
            SELECT Id, 
                   ACME__Operation__c, 
                   ACME__FirstOperand__c, 
                   ACME__SecondOperand__c, 
                   ACME__Result__c
            FROM ACME_CalculationHistory__c
            WHERE Id IN :calculationIds
            WITH SECURITY_ENFORCED
            LIMIT 10000
        ];
    }

    /**
     * Retrieve recent calculation history records
     * @param recordLimit Number of records to retrieve
     * @return List of recent ACME_CalculationHistory__c records
     */
    public static List<ACME_CalculationHistory__c> selectRecentCalculations(Integer recordLimit) {
        return [
            SELECT Id, 
                   ACME__Operation__c, 
                   ACME__FirstOperand__c, 
                   ACME__SecondOperand__c, 
                   ACME__Result__c
            FROM ACME_CalculationHistory__c
            ORDER BY CreatedDate DESC
            LIMIT :recordLimit
        ];
    }
}