/**
 * ACME Calculator Service for performing mathematical operations
 * and managing calculation history
 * @author Acme Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_CalculatorService {
    
    /**
     * Perform addition operation and record calculation history
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
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'add', e);
            throw e;
        }
    }

    /**
     * Perform subtraction operation and record calculation history
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
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'subtract', e);
            throw e;
        }
    }

    /**
     * Perform multiplication operation and record calculation history
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
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'multiply', e);
            throw e;
        }
    }

    /**
     * Perform division operation and record calculation history
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @return Calculation result
     * @throws DivideByZeroException if secondOperand is zero
     */
    public static Decimal divide(Decimal firstOperand, Decimal secondOperand) {
        try {
            if (secondOperand == 0) {
                throw new DivideByZeroException('Cannot divide by zero');
            }
            Decimal result = firstOperand / secondOperand;
            createCalculationHistory('Division', firstOperand, secondOperand, result);
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'divide', e);
            throw e;
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
            Operation__c = operation,
            FirstOperand__c = firstOperand,
            SecondOperand__c = secondOperand,
            Result__c = result
        );
        
        try {
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'createCalculationHistory', e);
        }
    }
}