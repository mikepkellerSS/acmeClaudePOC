/**
 * Service class for performing mathematical operations
 * Follows Acme Corp coding standards and best practices
 */
public with sharing class ACME_MathService {
    
    /**
     * Perform addition and log calculation history
     * @param a First number to add
     * @param b Second number to add
     * @return Calculation result
     */
    public static Decimal add(Decimal a, Decimal b) {
        try {
            Decimal result = a + b;
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Addition', 
                String.valueOf(a) + ' + ' + String.valueOf(b)
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'add', e);
            throw new AuraHandledException('Error performing addition: ' + e.getMessage());
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
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Subtraction', 
                String.valueOf(a) + ' - ' + String.valueOf(b)
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'subtract', e);
            throw new AuraHandledException('Error performing subtraction: ' + e.getMessage());
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
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Multiplication', 
                String.valueOf(a) + ' * ' + String.valueOf(b)
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'multiply', e);
            throw new AuraHandledException('Error performing multiplication: ' + e.getMessage());
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
            ACME_CalculationHistoryService.createCalculationHistory(
                result, 
                'Division', 
                String.valueOf(a) + ' / ' + String.valueOf(b)
            );
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_MathService', 'divide', e);
            throw new AuraHandledException('Error performing division: ' + e.getMessage());
        }
    }
}