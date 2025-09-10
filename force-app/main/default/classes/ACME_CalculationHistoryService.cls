/**
 * Service class for managing Calculation History records
 * Follows Acme Corp service layer pattern and best practices
 */
public with sharing class ACME_CalculationHistoryService {
    
    /**
     * Create a new calculation history record
     * @param calculationResult Result of the calculation
     * @param calculationType Type of calculation performed
     * @param operands List of numbers used in calculation
     * @return Created Calculation History record
     */
    public static ACME_CalculationHistory__c createCalculationHistory(
        Decimal calculationResult, 
        String calculationType, 
        List<Decimal> operands
    ) {
        try {
            String operandsDetail = String.join(
                new List<String>{
                    String.valueOf(operands[0]), 
                    calculationType, 
                    String.valueOf(operands[1])
                }, 
                ' '
            );

            ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
                Name = operandsDetail + ' = ' + String.valueOf(calculationResult),
                ACME__CalculationHistoryNumber__c = calculationResult,
                ACME__CalculationType__c = calculationType
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