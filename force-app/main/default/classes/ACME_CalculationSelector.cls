/**
 * Selector class for retrieving Calculation History records
 * Follows Acme Corp selector pattern and best practices
 */
public with sharing class ACME_CalculationSelector {
    
    /**
     * Select Calculation History records by ID
     * @param calculationIds Set of Calculation History record IDs
     * @return List of Calculation History records
     */
    public static List<ACME_CalculationHistory__c> selectById(Set<Id> calculationIds) {
        return [
            SELECT Id, 
                   Name, 
                   ACME__CalculationHistoryNumber__c, 
                   ACME__CalculationType__c 
            FROM ACME_CalculationHistory__c 
            WHERE Id IN :calculationIds
        ];
    }

    /**
     * Select Calculation History records by Calculation Type
     * @param calculationType Type of calculation to filter
     * @return List of Calculation History records
     */
    public static List<ACME_CalculationHistory__c> selectByCalculationType(String calculationType) {
        return [
            SELECT Id, 
                   Name, 
                   ACME__CalculationHistoryNumber__c, 
                   ACME__CalculationType__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = :calculationType
            ORDER BY CreatedDate DESC
            LIMIT 1000
        ];
    }

    /**
     * Get recent calculation history
     * @param limitCount Number of records to retrieve
     * @return List of recent Calculation History records
     */
    public static List<ACME_CalculationHistory__c> getRecentCalculations(Integer limitCount) {
        return [
            SELECT Id, 
                   Name, 
                   ACME__CalculationHistoryNumber__c, 
                   ACME__CalculationType__c,
                   CreatedDate
            FROM ACME_CalculationHistory__c 
            ORDER BY CreatedDate DESC
            LIMIT :limitCount
        ];
    }
}