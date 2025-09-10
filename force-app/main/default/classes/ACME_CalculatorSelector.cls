public class ACME_CalculatorSelector {
    public List<ACME_CalculationHistory__c> getCalculationHistoryByOperation(String operation) {
        try {
            return [SELECT Id, FirstOperand__c, SecondOperand__c, Operation__c, Result__c 
                    FROM ACME_CalculationHistory__c 
                    WHERE Operation__c = :operation 
                    LIMIT 1000];
        } catch (Exception ex) {
            ACME_ErrorHandler.handleException(ex);
            return new List<ACME_CalculationHistory__c>();
        }
    }

    public List<ACME_CalculationHistory__c> getAllCalculationHistory() {
        try {
            return [SELECT Id, FirstOperand__c, SecondOperand__c, Operation__c, Result__c 
                    FROM ACME_CalculationHistory__c 
                    ORDER BY CreatedDate DESC 
                    LIMIT 1000];
        } catch (Exception ex) {
            ACME_ErrorHandler.handleException(ex);
            return new List<ACME_CalculationHistory__c>();
        }
    }
}