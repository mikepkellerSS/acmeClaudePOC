/**
 * Service class for managing Calculation History records
 */
public with sharing class ACME_CalculationHistoryService {
    
    /**
     * Create a new calculation history record
     * @param calculationType Type of calculation performed
     * @param operand1 First operand
     * @param operand2 Second operand
     * @param result Calculation result
     * @return Created calculation history record
     */
    public static ACME_CalculationHistory__c createCalculationHistory(
        String calculationType, 
        Decimal operand1, 
        Decimal operand2, 
        Decimal result
    ) {
        try {
            ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
                ACME__CalculationType__c = calculationType,
                ACME__CalculationHistoryNumber__c = result
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
     * @param daysToRetain Number of days to retain records
     */
    public static void deleteOldCalculationHistories(Integer daysToRetain) {
        try {
            DateTime cutoffDate = System.now().addDays(-daysToRetain);
            
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