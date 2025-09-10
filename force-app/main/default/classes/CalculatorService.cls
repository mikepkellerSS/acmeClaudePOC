public with sharing class CalculatorService {
    
    /**
     * Performs addition operation
     * @param a First operand
     * @param b Second operand
     * @return Sum of a and b
     */
    public static Decimal add(Decimal a, Decimal b) {
        Decimal result = a + b;
        saveCalculationHistory(a, b, 'ADD', result);
        return result;
    }
    
    /**
     * Performs subtraction operation
     * @param a First operand
     * @param b Second operand
     * @return Difference of a and b
     */
    public static Decimal subtract(Decimal a, Decimal b) {
        Decimal result = a - b;
        saveCalculationHistory(a, b, 'SUBTRACT', result);
        return result;
    }
    
    /**
     * Performs multiplication operation
     * @param a First operand
     * @param b Second operand
     * @return Product of a and b
     */
    public static Decimal multiply(Decimal a, Decimal b) {
        Decimal result = a * b;
        saveCalculationHistory(a, b, 'MULTIPLY', result);
        return result;
    }
    
    /**
     * Performs division operation
     * @param a First operand (dividend)
     * @param b Second operand (divisor)
     * @return Quotient of a divided by b
     * @throws IllegalArgumentException if divisor is zero
     */
    public static Decimal divide(Decimal a, Decimal b) {
        if (b == 0) {
            throw new IllegalArgumentException('Division by zero is not allowed');
        }
        Decimal result = a / b;
        saveCalculationHistory(a, b, 'DIVIDE', result);
        return result;
    }
    
    /**
     * Retrieves calculation history
     * @param limitCount Number of records to retrieve (default 100)
     * @return List of calculation history records
     */
    public static List<CalculationHistory__c> getCalculationHistory(Integer limitCount) {
        if (limitCount == null || limitCount <= 0) {
            limitCount = 100;
        }
        
        return [
            SELECT Id, FirstOperand__c, SecondOperand__c, Operation__c, Result__c, CreatedDate
            FROM CalculationHistory__c
            ORDER BY CreatedDate DESC
            LIMIT :limitCount
        ];
    }
    
    /**
     * Retrieves calculation history with default limit
     * @return List of calculation history records (last 100)
     */
    public static List<CalculationHistory__c> getCalculationHistory() {
        return getCalculationHistory(100);
    }
    
    /**
     * Clears all calculation history
     * @return Number of records deleted
     */
    public static Integer clearCalculationHistory() {
        List<CalculationHistory__c> historyToDelete = [SELECT Id FROM CalculationHistory__c];
        Integer recordCount = historyToDelete.size();
        
        if (!historyToDelete.isEmpty()) {
            delete historyToDelete;
        }
        
        return recordCount;
    }
    
    /**
     * Private helper method to save calculation history
     * @param firstOperand First operand
     * @param secondOperand Second operand
     * @param operation Operation performed
     * @param result Result of the operation
     */
    private static void saveCalculationHistory(Decimal firstOperand, Decimal secondOperand, String operation, Decimal result) {
        try {
            CalculationHistory__c history = new CalculationHistory__c(
                FirstOperand__c = firstOperand,
                SecondOperand__c = secondOperand,
                Operation__c = operation,
                Result__c = result
            );
            
            insert history;
        } catch (Exception e) {
            System.debug('Error saving calculation history: ' + e.getMessage());
            // Continue execution even if history save fails
        }
    }
}