/**
 * Service class for performing mathematical operations
 * and tracking calculation history
 */
public with sharing class ACME_MathService {
    
    /**
     * Perform addition and log calculation history
     * @param a First number to add
     * @param b Second number to add
     * @return Result of addition
     */
    public static Decimal add(Decimal a, Decimal b) {
        Decimal result = a + b;
        logCalculation(a, b, result, 'Addition');
        return result;
    }

    /**
     * Perform subtraction and log calculation history
     * @param a Number to subtract from
     * @param b Number to subtract
     * @return Result of subtraction
     */
    public static Decimal subtract(Decimal a, Decimal b) {
        Decimal result = a - b;
        logCalculation(a, b, result, 'Subtraction');
        return result;
    }

    /**
     * Perform multiplication and log calculation history
     * @param a First number to multiply
     * @param b Second number to multiply
     * @return Result of multiplication
     */
    public static Decimal multiply(Decimal a, Decimal b) {
        Decimal result = a * b;
        logCalculation(a, b, result, 'Multiplication');
        return result;
    }

    /**
     * Perform division and log calculation history
     * @param a Number to divide
     * @param b Number to divide by
     * @return Result of division
     * @throws MathServiceException If division by zero
     */
    public static Decimal divide(Decimal a, Decimal b) {
        if (b == 0) {
            throw new MathServiceException('Cannot divide by zero');
        }
        Decimal result = a / b;
        logCalculation(a, b, result, 'Division');
        return result;
    }

    /**
     * Log calculation history record
     * @param a First operand
     * @param b Second operand
     * @param result Calculation result
     * @param calculationType Type of calculation
     */
    private static void logCalculation(Decimal a, Decimal b, Decimal result, String calculationType) {
        try {
            ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
                ACME__CalculationHistoryNumber__c = result,
                ACME__CalculationType__c = calculationType,
                Name = a + ' ' + calculationType + ' ' + b + ' = ' + result
            );
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'logCalculation', e);
        }
    }

    /**
     * Custom exception for math service errors
     */
    public class MathServiceException extends Exception {}
}