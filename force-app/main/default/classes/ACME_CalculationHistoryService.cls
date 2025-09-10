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
     * @return Map of calculation type to count
     */
    public static Map<String, Integer> getCalculationTypeCounts() {
        AggregateResult[] results = [
            SELECT ACME__CalculationType__c, COUNT(Id) calcCount 
            FROM ACME_CalculationHistory__c 
            GROUP BY ACME__CalculationType__c
        ];
        
        Map<String, Integer> calculationCounts = new Map<String, Integer>();
        for (AggregateResult ar : results) {
            calculationCounts.put(
                (String)ar.get('ACME__CalculationType__c'), 
                (Integer)ar.get('calcCount')
            );
        }
        
        return calculationCounts;
    }
}