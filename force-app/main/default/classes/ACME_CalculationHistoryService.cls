/**
 * Service class for managing Calculation History records
 * Follows Acme Corp service layer pattern and best practices
 */
public with sharing class ACME_CalculationHistoryService {
    
    /**
     * Create a new Calculation History record
     * @param result Calculated result
     * @param calculationType Type of calculation performed
     * @param operands List of numbers used in calculation
     * @return Created Calculation History record
     */
    public static ACME_CalculationHistory__c createCalculationHistory(
        Decimal result, 
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

            ACME_CalculationHistory__c calcHistory = new ACME_CalculationHistory__c(
                Name = operandsDetail + ' = ' + String.valueOf(result),
                ACME__CalculationHistoryNumber__c = result,
                ACME__CalculationType__c = calculationType
            );

            insert calcHistory;
            return calcHistory;
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
            
            List<ACME_CalculationHistory__c> oldRecords = [
                SELECT Id 
                FROM ACME_CalculationHistory__c 
                WHERE CreatedDate < :cutoffDate
            ];

            if (!oldRecords.isEmpty()) {
                delete oldRecords;
            }
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculationHistoryService', 'deleteOldCalculationHistories', e);
            throw e;
        }
    }
}