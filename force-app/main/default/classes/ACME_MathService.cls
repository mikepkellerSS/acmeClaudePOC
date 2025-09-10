/**
 * Service class for performing mathematical operations
 * Follows Acme Corp coding standards and best practices
 */
public with sharing class ACME_MathService {
    
    /**
     * Perform addition of two numbers and log calculation history
     * @param num1 First number to add
     * @param num2 Second number to add
     * @return Decimal result of addition
     */
    public static Decimal add(Decimal num1, Decimal num2) {
        try {
            Decimal result = num1 + num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Addition', 
                new List<Decimal>{num1, num2}
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
     * @return Decimal result of subtraction
     */
    public static Decimal subtract(Decimal num1, Decimal num2) {
        try {
            Decimal result = num1 - num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Subtraction', 
                new List<Decimal>{num1, num2}
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
     * @return Decimal result of multiplication
     */
    public static Decimal multiply(Decimal num1, Decimal num2) {
        try {
            Decimal result = num1 * num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Multiplication', 
                new List<Decimal>{num1, num2}
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
     * @return Decimal result of division
     * @throws DivideByZeroException if divisor is zero
     */
    public static Decimal divide(Decimal num1, Decimal num2) {
        try {
            if (num2 == 0) {
                throw new DivideByZeroException('Cannot divide by zero');
            }
            Decimal result = num1 / num2;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Division', 
                new List<Decimal>{num1, num2}
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'divide', e);
            throw e;
        }
    }
}