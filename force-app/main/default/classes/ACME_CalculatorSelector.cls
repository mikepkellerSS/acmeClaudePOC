/**
 * @description Selector class for querying calculation history
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_CalculatorSelector {
    
    /**
     * Retrieve calculation history with security enforced
     * @param limitRecords Number of records to retrieve
     * @return List of calculation history records
     */
    public static List<ACME_Calculation_History__c> getCalculationHistory(Integer limitRecords) {
        if (!Schema.sObjectType.ACME_Calculation_History__c.isAccessible()) {
            ACME_ErrorHandler.handleError('No access to Calculation History object');
        }
        
        return [
            SELECT ACME_Operation_Type__c, 
                   ACME_First_Number__c, 
                   ACME_Second_Number__c, 
                   ACME_Result__c, 
                   ACME_Timestamp__c 
            FROM ACME_Calculation_History__c 
            ORDER BY ACME_Timestamp__c DESC 
            LIMIT :limitRecords
        ];
    }
}