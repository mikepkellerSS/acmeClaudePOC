/**
 * Service class for managing Calculation History records
 * Follows Acme Corp service layer pattern and best practices
 */
public with sharing class ACME_CalculationHistoryService {
    
    /**
     * Create a new calculation history record
     * @param calculationResult Result of the mathematical operation
     * @param calculationType Type of calculation performed
     * @param operands List of operands used in the calculation
     * @return Created calculation history record
     */
    public static ACME_CalculationHistory__c createCalculationHistory(
        Decimal calculationResult, 
        String calculationType, 
        List<String> operands
    ) {
        try {
            ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
                ACME__CalculationHistoryNumber__c = calculationResult,
                ACME__CalculationType__c = calculationType,
                Name = String.format('{0} {1} {2} = {3}', operands + new List<String>{String.valueOf(calculationResult)})
            );
            
            insert history;
            return history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculationHistoryService', 'createCalculationHistory', e);
            throw e;
        }
    }

    /**
     * Delete old calculation history records
     * @param daysToRetain Number of days to retain calculation history
     */
    public static void deleteOldCalculationHistories(Integer daysToRetain) {
        try {
            Datetime cutoffDate = System.now().addDays(-daysToRetain);
            List<ACME_CalculationHistory__c> oldHistories = [
                SELECT Id 
                FROM ACME_CalculationHistory__c 
                WHERE CreatedDate < :cutoffDate
            ];
            
            if (!oldHistories.isEmpty()) {
                delete oldHistories;
            }
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculationHistoryService', 'deleteOldCalculationHistories', e);
            throw e;
        }
    }
}