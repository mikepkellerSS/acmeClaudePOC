/**
 * Selector class for retrieving Calculation History records
 * @author Acme Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_CalculatorSelector {
    
    /**
     * Retrieve calculation history records by operation type
     * @param operation Type of mathematical operation
     * @return List of calculation history records
     */
    public static List<ACME_CalculationHistory__c> getCalculationHistoryByOperation(String operation) {
        try {
            return [
                SELECT Id, 
                       Operation__c, 
                       FirstOperand__c, 
                       SecondOperand__c, 
                       Result__c, 
                       CreatedDate 
                FROM ACME_CalculationHistory__c 
                WHERE Operation__c = :operation 
                ORDER BY CreatedDate DESC 
                LIMIT 1000
            ];
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorSelector', 'getCalculationHistoryByOperation', e);
            return new List<ACME_CalculationHistory__c>();
        }
    }

    /**
     * Retrieve all calculation history records
     * @return List of all calculation history records
     */
    public static List<ACME_CalculationHistory__c> getAllCalculationHistory() {
        try {
            return [
                SELECT Id, 
                       Operation__c, 
                       FirstOperand__c, 
                       SecondOperand__c, 
                       Result__c, 
                       CreatedDate 
                FROM ACME_CalculationHistory__c 
                ORDER BY CreatedDate DESC 
                LIMIT 5000
            ];
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorSelector', 'getAllCalculationHistory', e);
            return new List<ACME_CalculationHistory__c>();
        }
    }
}