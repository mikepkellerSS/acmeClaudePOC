/**
 * Service class for performing mathematical calculations
 * and storing calculation history
 */
public with sharing class ACME_CalculatorService {
    
    /**
     * Perform addition and log calculation history
     * @param a First number to add
     * @param b Second number to add
     * @return Calculation result
     */
    public static Decimal add(Decimal a, Decimal b) {
        try {
            Decimal result = a + b;
            logCalculation(a, b, result, 'Addition');
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'add', e);
            throw e;
        }
    }

    /**
     * Perform subtraction and log calculation history
     * @param a Number to subtract from
     * @param b Number to subtract
     * @return Calculation result
     */
    public static Decimal subtract(Decimal a, Decimal b) {
        try {
            Decimal result = a - b;
            logCalculation(a, b, result, 'Subtraction');
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'subtract', e);
            throw e;
        }
    }

    /**
     * Perform multiplication and log calculation history
     * @param a First number to multiply
     * @param b Second number to multiply
     * @return Calculation result
     */
    public static Decimal multiply(Decimal a, Decimal b) {
        try {
            Decimal result = a * b;
            logCalculation(a, b, result, 'Multiplication');
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'multiply', e);
            throw e;
        }
    }

    /**
     * Perform division and log calculation history
     * @param a Number to divide
     * @param b Number to divide by
     * @return Calculation result
     */
    public static Decimal divide(Decimal a, Decimal b) {
        try {
            if (b == 0) {
                throw new ArithmeticException('Division by zero is not allowed');
            }
            Decimal result = a / b;
            logCalculation(a, b, result, 'Division');
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'divide', e);
            throw e;
        }
    }

    /**
     * Log calculation history record
     * @param a First operand
     * @param b Second operand
     * @param result Calculation result
     * @param calculationType Type of calculation
     */
    private static void logCalculation(Decimal a, Decimal b, Decimal result, String calculationType) {
        ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
            ACME__CalculationHistoryNumber__c = result,
            ACME__CalculationType__c = calculationType,
            Name = a + ' ' + calculationType + ' ' + b + ' = ' + result
        );
        
        try {
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'logCalculation', e);
        }
    }
}