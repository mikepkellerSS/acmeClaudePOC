/**
 * Service class for performing mathematical calculations
 * Follows Service Layer Pattern with error handling
 */
public with sharing class ACME__CalculatorService {
    
    /**
     * Perform addition and store calculation history
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @return Calculation result
     */
    public static Decimal add(Decimal firstOperand, Decimal secondOperand) {
        try {
            Decimal result = firstOperand + secondOperand;
            createCalculationHistory('Addition', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__CalculatorService', 'add', e);
            throw new ACME__CalculatorException('Addition failed: ' + e.getMessage());
        }
    }

    /**
     * Perform subtraction and store calculation history
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @return Calculation result
     */
    public static Decimal subtract(Decimal firstOperand, Decimal secondOperand) {
        try {
            Decimal result = firstOperand - secondOperand;
            createCalculationHistory('Subtraction', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__CalculatorService', 'subtract', e);
            throw new ACME__CalculatorException('Subtraction failed: ' + e.getMessage());
        }
    }

    /**
     * Perform multiplication and store calculation history
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @return Calculation result
     */
    public static Decimal multiply(Decimal firstOperand, Decimal secondOperand) {
        try {
            Decimal result = firstOperand * secondOperand;
            createCalculationHistory('Multiplication', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__CalculatorService', 'multiply', e);
            throw new ACME__CalculatorException('Multiplication failed: ' + e.getMessage());
        }
    }

    /**
     * Perform division and store calculation history
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @return Calculation result
     */
    public static Decimal divide(Decimal firstOperand, Decimal secondOperand) {
        try {
            if (secondOperand == 0) {
                throw new ACME__CalculatorException('Division by zero is not allowed');
            }
            Decimal result = firstOperand / secondOperand;
            createCalculationHistory('Division', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__CalculatorService', 'divide', e);
            throw new ACME__CalculatorException('Division failed: ' + e.getMessage());
        }
    }

    /**
     * Create calculation history record
     * @param operation Type of mathematical operation
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @param result Calculation result
     */
    private static void createCalculationHistory(
        String operation, 
        Decimal firstOperand, 
        Decimal secondOperand, 
        Decimal result
    ) {
        ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
            ACME__Operation__c = operation,
            ACME__FirstOperand__c = firstOperand,
            ACME__SecondOperand__c = secondOperand,
            ACME__Result__c = result
        );
        
        try {
            insert history;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__CalculatorService', 'createCalculationHistory', e);
        }
    }

    /**
     * Custom exception for calculator service
     */
    public class ACME__CalculatorException extends Exception {}
}