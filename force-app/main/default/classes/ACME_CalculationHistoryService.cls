/**
 * Service class for managing Calculation History records
 */
public with sharing class ACME_CalculationHistoryService {
    
    /**
     * Delete old calculation history records
     * @param daysToRetain Number of days to retain records
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
        }
    }

    /**
     * Get total number of calculation history records
     * @return Total number of records
     */
    public static Integer getTotalCalculationHistoryCount() {
        return [
            SELECT COUNT() 
            FROM ACME_CalculationHistory__c
        ];
    }
}