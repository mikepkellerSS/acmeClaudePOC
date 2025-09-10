/**
 * ACME Calculator Service
 * Provides basic mathematical operations and calculation history management
 * @author Salesforce Studio
 * @date 2024-02-15
 */
public with sharing class ACME_CalculatorService {
    
    /**
     * Enum for supported mathematical operations
     */
    public enum MathOperation {
        ADD, SUBTRACT, MULTIPLY, DIVIDE
    }

    /**
     * Perform mathematical operation and record calculation history
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

            // Record calculation history
            recordCalculationHistory(firstOperand, secondOperand, operation, result);
            
            return result;
        } catch (Exception e) {
            // Log error and rethrow
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'calculate', e);
            throw e;
        }
    }

    /**
     * Record calculation history in custom object
     * @param firstOperand First operand used in calculation
     * @param secondOperand Second operand used in calculation
     * @param operation Operation performed
     * @param result Calculation result
     */
    private static void recordCalculationHistory(Decimal firstOperand, Decimal secondOperand, 
                                                 MathOperation operation, Decimal result) {
        ACME_CalculationHistory__c history = new ACME_CalculationHistory__c(
            ACME__FirstOperand__c = firstOperand,
            ACME__SecondOperand__c = secondOperand,
            ACME__Operation__c = operation.name(),
            ACME__Result__c = result
        );

        try {
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('ACME_CalculatorService', 'recordCalculationHistory', e);
        }
    }
}