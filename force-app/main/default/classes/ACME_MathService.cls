/**
 * Service class for performing mathematical operations
 * Follows Acme Corp coding standards and best practices
 */
public with sharing class ACME_MathService {
    
    /**
     * Perform addition of two numbers and log calculation history
     * @param num1 First number to add
     * @param num2 Second number to add
     * @return Calculation result
     */
    public static Decimal add(Decimal num1, Decimal num2) {
        try {
            Decimal result = num1 + num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Addition', 
                new List<String>{String.valueOf(num1), String.valueOf(num2)}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'add', e);
            throw e;
        }
    }

    /**
     * Perform subtraction of two numbers and log calculation history
     * @param num1 First number to subtract from
     * @param num2 Number to subtract
     * @return Calculation result
     */
    public static Decimal subtract(Decimal num1, Decimal num2) {
        try {
            Decimal result = num1 - num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Subtraction', 
                new List<String>{String.valueOf(num1), String.valueOf(num2)}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'subtract', e);
            throw e;
        }
    }

    /**
     * Perform multiplication of two numbers and log calculation history
     * @param num1 First number to multiply
     * @param num2 Second number to multiply
     * @return Calculation result
     */
    public static Decimal multiply(Decimal num1, Decimal num2) {
        try {
            Decimal result = num1 * num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Multiplication', 
                new List<String>{String.valueOf(num1), String.valueOf(num2)}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'multiply', e);
            throw e;
        }
    }

    /**
     * Perform division of two numbers and log calculation history
     * @param num1 Dividend
     * @param num2 Divisor
     * @return Calculation result
     */
    public static Decimal divide(Decimal num1, Decimal num2) {
        try {
            if (num2 == 0) {
                throw new MathException('Division by zero is not allowed');
            }
            Decimal result = num1 / num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Division', 
                new List<String>{String.valueOf(num1), String.valueOf(num2)}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'divide', e);
            throw e;
        }
    }

    // Custom exception for math-related errors
    public class MathException extends Exception {}
}