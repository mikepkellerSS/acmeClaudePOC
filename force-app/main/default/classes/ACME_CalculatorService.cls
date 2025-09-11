/**
 * ACME Calculator Service for performing basic mathematical operations
 * and tracking calculation history
 */
public with sharing class ACME_CalculatorService {
    
    /**
     * Perform addition and log calculation history
     * @param firstOperand First number in the calculation
     * @param secondOperand Second number in the calculation
     * @return Calculation result
     */
    public static Decimal add(Decimal firstOperand, Decimal secondOperand) {
        try {
            Decimal result = firstOperand + secondOperand;
            logCalculation('Addition', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'add', e);
            throw e;
        }
    }

    /**
     * Perform subtraction and log calculation history
     * @param firstOperand First number in the calculation
     * @param secondOperand Second number in the calculation
     * @return Calculation result
     */
    public static Decimal subtract(Decimal firstOperand, Decimal secondOperand) {
        try {
            Decimal result = firstOperand - secondOperand;
            logCalculation('Subtraction', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'subtract', e);
            throw e;
        }
    }

    /**
     * Perform multiplication and log calculation history
     * @param firstOperand First number in the calculation
     * @param secondOperand Second number in the calculation
     * @return Calculation result
     */
    public static Decimal multiply(Decimal firstOperand, Decimal secondOperand) {
        try {
            Decimal result = firstOperand * secondOperand;
            logCalculation('Multiplication', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'multiply', e);
            throw e;
        }
    }

    /**
     * Perform division and log calculation history
     * @param firstOperand First number in the calculation
     * @param secondOperand Second number in the calculation
     * @return Calculation result
     * @throws DivideByZeroException if secondOperand is zero
     */
    public static Decimal divide(Decimal firstOperand, Decimal secondOperand) {
        try {
            if (secondOperand == 0) {
                throw new DivideByZeroException('Cannot divide by zero');
            }
            Decimal result = firstOperand / secondOperand;
            logCalculation('Division', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'divide', e);
            throw e;
        }
    }

    /**
     * Log calculation history to custom object
     * @param operation Type of mathematical operation
     * @param firstOperand First number in the calculation
     * @param secondOperand Second number in the calculation
     * @param result Calculation result
     */
    private static void logCalculation(
        String operation, 
        Decimal firstOperand, 
        Decimal secondOperand, 
        Decimal result
    ) {
        ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
            Operation__c = operation,
            FirstOperand__c = firstOperand,
            SecondOperand__c = secondOperand,
            Result__c = result
        );
        
        try {
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'logCalculation', e);
        }
    }
}