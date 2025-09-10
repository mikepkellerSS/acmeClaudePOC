/**
 * ACME Calculator Service
 * Provides basic mathematical operations and calculation history management
 * @author Salesforce Studio
 * @date 2024-02-15
 */
public with sharing class ACME_CalculatorService {
    
    public enum MathOperation {
        ADD, SUBTRACT, MULTIPLY, DIVIDE
    }

    /**
     * Perform mathematical operation and log calculation history
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @param operation Mathematical operation to perform
     * @return Calculation result
     */
    public static Decimal calculate(Decimal firstOperand, Decimal secondOperand, MathOperation operation) {
        Decimal result;
        
        try {
            switch on operation {
                when ADD {
                    result = firstOperand + secondOperand;
                }
                when SUBTRACT {
                    result = firstOperand - secondOperand;
                }
                when MULTIPLY {
                    result = firstOperand * secondOperand;
                }
                when DIVIDE {
                    if (secondOperand == 0) {
                        throw new ArithmeticException('Division by zero is not allowed');
                    }
                    result = firstOperand / secondOperand;
                }
            }

            // Log calculation history
            logCalculation(firstOperand, secondOperand, operation, result);
            
            return result;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'calculate', e);
            throw e;
        }
    }

    /**
     * Log calculation history record
     * @param firstOperand First number in calculation
     * @param secondOperand Second number in calculation
     * @param operation Mathematical operation performed
     * @param result Calculation result
     */
    private static void logCalculation(Decimal firstOperand, Decimal secondOperand, MathOperation operation, Decimal result) {
        ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
            Operation__c = operation.name(),
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