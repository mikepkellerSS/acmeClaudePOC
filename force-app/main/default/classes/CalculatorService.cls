/**
 * Calculator Service - Provides basic math operations and stores calculation history
 * @author Salesforce Developer
 * @date 2024
 */
public with sharing class CalculatorService {
    
    /**
     * Performs addition operation
     * @param operand1 First number
     * @param operand2 Second number
     * @return Result of addition
     */
    public static Decimal add(Decimal operand1, Decimal operand2) {
        try {
            Decimal result = operand1 + operand2;
            saveCalculationHistory(operand1, operand2, 'Addition', result);
            return result;
        } catch (Exception e) {
            System.debug('Error in addition: ' + e.getMessage());
            throw new CalculatorException('Addition operation failed: ' + e.getMessage());
        }
    }
    
    /**
     * Performs subtraction operation
     * @param operand1 First number
     * @param operand2 Second number
     * @return Result of subtraction
     */
    public static Decimal subtract(Decimal operand1, Decimal operand2) {
        try {
            Decimal result = operand1 - operand2;
            saveCalculationHistory(operand1, operand2, 'Subtraction', result);
            return result;
        } catch (Exception e) {
            System.debug('Error in subtraction: ' + e.getMessage());
            throw new CalculatorException('Subtraction operation failed: ' + e.getMessage());
        }
    }
    
    /**
     * Performs multiplication operation
     * @param operand1 First number
     * @param operand2 Second number
     * @return Result of multiplication
     */
    public static Decimal multiply(Decimal operand1, Decimal operand2) {
        try {
            Decimal result = operand1 * operand2;
            saveCalculationHistory(operand1, operand2, 'Multiplication', result);
            return result;
        } catch (Exception e) {
            System.debug('Error in multiplication: ' + e.getMessage());
            throw new CalculatorException('Multiplication operation failed: ' + e.getMessage());
        }
    }
    
    /**
     * Performs division operation
     * @param operand1 First number (dividend)
     * @param operand2 Second number (divisor)
     * @return Result of division
     * @throws CalculatorException when dividing by zero
     */
    public static Decimal divide(Decimal operand1, Decimal operand2) {
        try {
            if (operand2 == 0) {
                throw new CalculatorException('Division by zero is not allowed');
            }
            Decimal result = operand1 / operand2;
            saveCalculationHistory(operand1, operand2, 'Division', result);
            return result;
        } catch (CalculatorException e) {
            System.debug('Calculator error in division: ' + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.debug('Error in division: ' + e.getMessage());
            throw new CalculatorException('Division operation failed: ' + e.getMessage());
        }
    }
    
    /**
     * Saves calculation history to custom object
     * @param operand1 First operand
     * @param operand2 Second operand
     * @param operation Operation performed
     * @param result Result of operation
     */
    private static void saveCalculationHistory(Decimal operand1, Decimal operand2, String operation, Decimal result) {
        try {
            CalculationHistory__c history = new CalculationHistory__c(
                FirstOperand__c = operand1,
                SecondOperand__c = operand2,
                Operation__c = operation,
                Result__c = result
            );
            insert history;
        } catch (Exception e) {
            System.debug('Error saving calculation history: ' + e.getMessage());
            // Don't throw exception here to avoid breaking the calculation
        }
    }
    
    /**
     * Retrieves calculation history
     * @param limitCount Number of records to retrieve
     * @return List of calculation history records
     */
    public static List<CalculationHistory__c> getCalculationHistory(Integer limitCount) {
        try {
            return [
                SELECT Id, FirstOperand__c, SecondOperand__c, Operation__c, Result__c, CreatedDate
                FROM CalculationHistory__c
                ORDER BY CreatedDate DESC
                LIMIT :limitCount
            ];
        } catch (Exception e) {
            System.debug('Error retrieving calculation history: ' + e.getMessage());
            return new List<CalculationHistory__c>();
        }
    }
    
    /**
     * Custom exception class for calculator operations
     */
    public class CalculatorException extends Exception {}
}