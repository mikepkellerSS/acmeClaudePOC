/**
 * Calculator Service class that provides basic math operations
 * and stores calculation history in a custom object
 */
public with sharing class CalculatorService {
    
    /**
     * Performs addition operation
     * @param firstOperand First number to add
     * @param secondOperand Second number to add
     * @return Result of addition
     */
    public static Decimal add(Decimal firstOperand, Decimal secondOperand) {
        Decimal result = firstOperand + secondOperand;
        saveCalculationHistory(firstOperand, secondOperand, 'ADD', result);
        return result;
    }
    
    /**
     * Performs subtraction operation
     * @param firstOperand Number to subtract from
     * @param secondOperand Number to subtract
     * @return Result of subtraction
     */
    public static Decimal subtract(Decimal firstOperand, Decimal secondOperand) {
        Decimal result = firstOperand - secondOperand;
        saveCalculationHistory(firstOperand, secondOperand, 'SUBTRACT', result);
        return result;
    }
    
    /**
     * Performs multiplication operation
     * @param firstOperand First number to multiply
     * @param secondOperand Second number to multiply
     * @return Result of multiplication
     */
    public static Decimal multiply(Decimal firstOperand, Decimal secondOperand) {
        Decimal result = firstOperand * secondOperand;
        saveCalculationHistory(firstOperand, secondOperand, 'MULTIPLY', result);
        return result;
    }
    
    /**
     * Performs division operation
     * @param firstOperand Number to divide
     * @param secondOperand Number to divide by
     * @return Result of division
     * @throws CalculatorException when dividing by zero
     */
    public static Decimal divide(Decimal firstOperand, Decimal secondOperand) {
        if (secondOperand == 0) {
            throw new CalculatorException('Division by zero is not allowed');
        }
        Decimal result = firstOperand / secondOperand;
        saveCalculationHistory(firstOperand, secondOperand, 'DIVIDE', result);
        return result;
    }
    
    /**
     * Calculates power operation
     * @param base Base number
     * @param exponent Exponent
     * @return Result of power operation
     */
    public static Decimal power(Decimal base, Decimal exponent) {
        Decimal result = Math.pow(base.doubleValue(), exponent.doubleValue());
        saveCalculationHistory(base, exponent, 'POWER', result);
        return result;
    }
    
    /**
     * Calculates square root
     * @param operand Number to calculate square root for
     * @return Square root result
     * @throws CalculatorException when operand is negative
     */
    public static Decimal squareRoot(Decimal operand) {
        if (operand < 0) {
            throw new CalculatorException('Square root of negative number is not allowed');
        }
        Decimal result = Math.sqrt(operand.doubleValue());
        saveCalculationHistory(operand, null, 'SQRT', result);
        return result;
    }
    
    /**
     * Saves calculation history to custom object
     * @param firstOperand First operand
     * @param secondOperand Second operand (can be null for single operand operations)
     * @param operation Operation type
     * @param result Calculation result
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
        } catch (DmlException e) {
            System.debug('Error saving calculation history: ' + e.getMessage());
        }
    }
    
    /**
     * Retrieves calculation history
     * @param limitCount Number of records to retrieve
     * @return List of calculation history records
     */
    public static List<CalculationHistory__c> getCalculationHistory(Integer limitCount) {
        return [
            SELECT Id, FirstOperand__c, SecondOperand__c, Operation__c, Result__c, CreatedDate
            FROM CalculationHistory__c
            ORDER BY CreatedDate DESC
            LIMIT :limitCount
        ];
    }
    
    /**
     * Clears all calculation history
     */
    public static void clearHistory() {
        try {
            List<CalculationHistory__c> historyToDelete = [SELECT Id FROM CalculationHistory__c];
            if (!historyToDelete.isEmpty()) {
                delete historyToDelete;
            }
        } catch (DmlException e) {
            System.debug('Error clearing calculation history: ' + e.getMessage());
        }
    }
    
    /**
     * Custom exception class for calculator operations
     */
    public class CalculatorException extends Exception {}
}