/**
 * Selector class for retrieving ACME_CalculationHistory__c records
 * @author Salesforce Studio
 * @date 2024-02-15
 */
public with sharing class ACME_CalculatorSelector {
    
    /**
     * Retrieve calculation history records with optional filtering
     * @param operation Optional operation filter
     * @param startDate Optional start date filter
     * @param endDate Optional end date filter
     * @return List of calculation history records
     */
    public static List<ACME_CalculationHistory__c> getCalculationHistory(
        String operation, 
        DateTime startDate, 
        DateTime endDate
    ) {
        String query = 'SELECT Id, Operation__c, FirstOperand__c, SecondOperand__c, Result__c, CreatedDate ' +
                       'FROM ACME_CalculationHistory__c ' +
                       'WHERE Id != null ';
        
        List<Object> queryParams = new List<Object>();
        
        if (String.isNotBlank(operation)) {
            query += ' AND Operation__c = :operation ';
        }
        
        if (startDate != null) {
            query += ' AND CreatedDate >= :startDate ';
        }
        
        if (endDate != null) {
            query += ' AND CreatedDate <= :endDate ';
        }
        
        query += ' ORDER BY CreatedDate DESC LIMIT 1000';
        
        try {
            return Database.query(query);
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorSelector', 'getCalculationHistory', e);
            return new List<ACME_CalculationHistory__c>();
        }
    }

    /**
     * Get total number of calculations performed
     * @return Total number of calculation history records
     */
    public static Integer getTotalCalculationsCount() {
        try {
            return [SELECT COUNT() FROM ACME_CalculationHistory__c];
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorSelector', 'getTotalCalculationsCount', e);
            return 0;
        }
    }
}