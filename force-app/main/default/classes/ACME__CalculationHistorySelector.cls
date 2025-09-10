public with sharing class ACME__CalculationHistorySelector {
    public static List<ACME_CalculationHistory__c> selectRecentCalculations(Integer limitCount) {
        return [
            SELECT Id, 
                   ACME__Operation__c, 
                   ACME__FirstOperand__c, 
                   ACME__SecondOperand__c, 
                   ACME__Result__c, 
                   CreatedDate
            FROM ACME_CalculationHistory__c
            ORDER BY CreatedDate DESC
            LIMIT :limitCount
        ];
    }

    public static List<ACME_CalculationHistory__c> selectByOperation(String operation) {
        return [
            SELECT Id, 
                   ACME__Operation__c, 
                   ACME__FirstOperand__c, 
                   ACME__SecondOperand__c, 
                   ACME__Result__c
            FROM ACME_CalculationHistory__c
            WHERE ACME__Operation__c = :operation
        ];
    }
}