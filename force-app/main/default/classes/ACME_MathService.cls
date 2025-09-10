/**
 * Service class for performing mathematical operations
 * Follows Acme Corp coding standards and best practices
 */
public with sharing class ACME_MathService {
    
    /**
     * Perform addition of two numbers
     * @param a First number to add
     * @param b Second number to add
     * @return Result of addition
     */
    public static Decimal add(Decimal a, Decimal b) {
        try {
            Decimal result = a + b;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 'Addition', new List<Decimal>{a, b}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'add', e);
            throw e;
        }
    }

    /**
     * Perform subtraction of two numbers
     * @param a Number to subtract from
     * @param b Number to subtract
     * @return Result of subtraction
     */
    public static Decimal subtract(Decimal a, Decimal b) {
        try {
            Decimal result = a - b;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 'Subtraction', new List<Decimal>{a, b}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'subtract', e);
            throw e;
        }
    }

    /**
     * Perform multiplication of two numbers
     * @param a First number to multiply
     * @param b Second number to multiply
     * @return Result of multiplication
     */
    public static Decimal multiply(Decimal a, Decimal b) {
        try {
            Decimal result = a * b;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 'Multiplication', new List<Decimal>{a, b}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'multiply', e);
            throw e;
        }
    }

    /**
     * Perform division of two numbers
     * @param a Number to divide
     * @param b Number to divide by
     * @return Result of division
     */
    public static Decimal divide(Decimal a, Decimal b) {
        try {
            if (b == 0) {
                throw new MathException('Cannot divide by zero');
            }
            Decimal result = a / b;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 'Division', new List<Decimal>{a, b}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'divide', e);
            throw e;
        }
    }

    /**
     * Custom exception for math-related errors
     */
    public class MathException extends Exception {}
}