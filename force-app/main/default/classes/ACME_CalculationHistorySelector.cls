/**
 * Selector class for retrieving Calculation History records
 * Follows Acme Corp selector pattern and best practices
 */
public with sharing class ACME_CalculationHistorySelector {
    
    /**
     * Retrieve calculation history records by calculation type
     * @param calculationType Type of calculation to filter
     * @return List of matching calculation history records
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
     * Retrieve recent calculation history records
     * @param recordLimit Maximum number of records to retrieve
     * @return List of recent calculation history records
     */
    public static List<ACME_CalculationHistory__c> selectRecentCalculations(Integer recordLimit) {
        return [
            SELECT Id, 
                   Name, 
                   ACME__CalculationHistoryNumber__c, 
                   ACME__CalculationType__c, 
                   CreatedDate 
            FROM ACME_CalculationHistory__c 
            ORDER BY CreatedDate DESC 
            LIMIT :recordLimit
        ];
    }
}