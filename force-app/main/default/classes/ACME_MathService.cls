/**
 * Service class for performing mathematical operations
 * and storing calculation history
 */
public with sharing class ACME_MathService {
    
    /**
     * Perform addition and store calculation history
     * @param a First number to add
     * @param b Second number to add
     * @return Calculation result
     */
    public static Decimal add(Decimal a, Decimal b) {
        Decimal result = a + b;
        createCalculationHistory('Addition', a, b, result);
        return result;
    }

    /**
     * Perform subtraction and store calculation history
     * @param a Number to subtract from
     * @param b Number to subtract
     * @return Calculation result
     */
    public static Decimal subtract(Decimal a, Decimal b) {
        Decimal result = a - b;
        createCalculationHistory('Subtraction', a, b, result);
        return result;
    }

    /**
     * Perform multiplication and store calculation history
     * @param a First number to multiply
     * @param b Second number to multiply
     * @return Calculation result
     */
    public static Decimal multiply(Decimal a, Decimal b) {
        Decimal result = a * b;
        createCalculationHistory('Multiplication', a, b, result);
        return result;
    }

    /**
     * Perform division and store calculation history
     * @param a Number to divide
     * @param b Number to divide by
     * @return Calculation result
     * @throws MathServiceException If division by zero
     */
    public static Decimal divide(Decimal a, Decimal b) {
        if (b == 0) {
            throw new MathServiceException('Cannot divide by zero');
        }
        Decimal result = a / b;
        createCalculationHistory('Division', a, b, result);
        return result;
    }

    /**
     * Create a calculation history record
     * @param calculationType Type of calculation performed
     * @param a First operand
     * @param b Second operand
     * @param result Calculation result
     */
    private static void createCalculationHistory(
        String calculationType, 
        Decimal a, 
        Decimal b, 
        Decimal result
    ) {
        try {
            ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
                ACME__CalculationType__c = calculationType,
                ACME__CalculationHistoryNumber__c = result
            );
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'createCalculationHistory', e);
        }
    }

    /**
     * Custom exception for math service errors
     */
    public class MathServiceException extends Exception {}
}