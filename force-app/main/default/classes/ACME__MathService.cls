public with sharing class ACME__MathService {
    public static Decimal add(Decimal a, Decimal b) {
        try {
            Decimal result = a + b;
            logCalculation('Addition', a, b, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__MathService', 'add', e);
            throw e;
        }
    }

    public static Decimal subtract(Decimal a, Decimal b) {
        try {
            Decimal result = a - b;
            logCalculation('Subtraction', a, b, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__MathService', 'subtract', e);
            throw e;
        }
    }

    public static Decimal multiply(Decimal a, Decimal b) {
        try {
            Decimal result = a * b;
            logCalculation('Multiplication', a, b, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__MathService', 'multiply', e);
            throw e;
        }
    }

    public static Decimal divide(Decimal a, Decimal b) {
        try {
            if (b == 0) {
                throw new DivideByZeroException('Cannot divide by zero');
            }
            Decimal result = a / b;
            logCalculation('Division', a, b, result);
            return result;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__MathService', 'divide', e);
            throw e;
        }
    }

    private static void logCalculation(String operation, Decimal firstOperand, Decimal secondOperand, Decimal result) {
        ACME_CalculationHistory__c calcHistory = new ACME_CalculationHistory__c(
            ACME__Operation__c = operation,
            ACME__FirstOperand__c = firstOperand,
            ACME__SecondOperand__c = secondOperand,
            ACME__Result__c = result
        );
        
        try {
            insert calcHistory;
        } catch (Exception e) {
            ACME__ErrorHandler.logError('ACME__MathService', 'logCalculation', e);
        }
    }
}