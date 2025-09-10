public class ACME_CalculatorService {
    public static Decimal add(Decimal a, Decimal b) {
        try {
            Decimal result = a + b;
            saveCalculationHistory(a, b, '+', result);
            return result;
        } catch (Exception ex) {
            ACME_ErrorHandler.handleException(ex);
            return null;
        }
    }

    public static Decimal subtract(Decimal a, Decimal b) {
        try {
            Decimal result = a - b;
            saveCalculationHistory(a, b, '-', result);
            return result;
        } catch (Exception ex) {
            ACME_ErrorHandler.handleException(ex);
            return null;
        }
    }

    public static Decimal multiply(Decimal a, Decimal b) {
        try {
            Decimal result = a * b;
            saveCalculationHistory(a, b, '*', result);
            return result;
        } catch (Exception ex) {
            ACME_ErrorHandler.handleException(ex);
            return null;
        }
    }

    public static Decimal divide(Decimal a, Decimal b) {
        try {
            if (b == 0) {
                throw new ArithmeticException('Division by zero is not allowed');
            }
            Decimal result = a / b;
            saveCalculationHistory(a, b, '/', result);
            return result;
        } catch (ArithmeticException ex) {
            ACME_ErrorHandler.handleException(ex);
            return null;
        }
    }

    private static void saveCalculationHistory(Decimal a, Decimal b, String operation, Decimal result) {
        try {
            ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
                FirstOperand__c = a,
                SecondOperand__c = b,
                Operation__c = operation,
                Result__c = result
            );
            insert history;
        } catch (Exception ex) {
            ACME_ErrorHandler.handleException(ex);
        }
    }
}