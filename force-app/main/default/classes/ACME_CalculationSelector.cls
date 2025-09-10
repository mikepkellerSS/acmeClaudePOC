/**
 * Selector class for retrieving Calculation History records
 */
public with sharing class ACME_CalculationSelector {
    
    /**
     * Retrieve calculation history records by type
     * @param calculationType Type of calculation to filter
     * @return List of calculation history records
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
     * Retrieve calculation history records within a date range
     * @param startDate Beginning of date range
     * @param endDate End of date range
     * @return List of calculation history records
     */
    public static List<ACME_CalculationHistory__c> selectByDateRange(DateTime startDate, DateTime endDate) {
        return [
            SELECT Id, 
                   Name, 
                   ACME__CalculationHistoryNumber__c, 
                   ACME__CalculationType__c, 
                   CreatedDate 
            FROM ACME_CalculationHistory__c 
            WHERE CreatedDate >= :startDate 
              AND CreatedDate <= :endDate 
            ORDER BY CreatedDate DESC
        ];
    }
}