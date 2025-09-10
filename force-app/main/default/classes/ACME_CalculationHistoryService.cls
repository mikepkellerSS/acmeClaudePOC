/**
 * Service class for managing Calculation History records
 */
public with sharing class ACME_CalculationHistoryService {
    
    /**
     * Delete calculation history records older than specified days
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
        }
    }

    /**
     * Get total number of calculations by type
     * @param calculationType Type of calculation to count
     * @return Number of calculations of specified type
     */
    public static Integer getCalculationCountByType(String calculationType) {
        AggregateResult[] results = [
            SELECT COUNT(Id) totalCalculations 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = :calculationType
        ];
        
        return results.isEmpty() ? 0 : Integer.valueOf(results[0].get('totalCalculations'));
    }
}