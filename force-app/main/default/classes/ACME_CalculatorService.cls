/**
 * @description Calculator service for basic mathematical operations
 * @author Studio Science
 * @date 2024-03-15
 */
public with sharing class ACME_CalculatorService {
    
    /**
     * Performs addition with secure history tracking
     * @param num1 First number to add
     * @param num2 Second number to add
     * @return Calculation result
     */
    public static Decimal add(Decimal num1, Decimal num2) {
        if (num1 == null || num2 == null) {
            ACME_ErrorHandler.handleError('Invalid input: Numbers cannot be null');
        }
        
        Decimal result = num1 + num2;
        saveCalculationHistory('Addition', num1, num2, result);
        return result;
    }
    
    /**
     * Performs subtraction with secure history tracking
     * @param num1 First number to subtract from
     * @param num2 Number to subtract
     * @return Calculation result
     */
    public static Decimal subtract(Decimal num1, Decimal num2) {
        if (num1 == null || num2 == null) {
            ACME_ErrorHandler.handleError('Invalid input: Numbers cannot be null');
        }
        
        Decimal result = num1 - num2;
        saveCalculationHistory('Subtraction', num1, num2, result);
        return result;
    }
    
    /**
     * Performs multiplication with secure history tracking
     * @param num1 First number to multiply
     * @param num2 Second number to multiply
     * @return Calculation result
     */
    public static Decimal multiply(Decimal num1, Decimal num2) {
        if (num1 == null || num2 == null) {
            ACME_ErrorHandler.handleError('Invalid input: Numbers cannot be null');
        }
        
        Decimal result = num1 * num2;
        saveCalculationHistory('Multiplication', num1, num2, result);
        return result;
    }
    
    /**
     * Performs division with secure history tracking
     * @param num1 Dividend
     * @param num2 Divisor
     * @return Calculation result
     */
    public static Decimal divide(Decimal num1, Decimal num2) {
        if (num1 == null || num2 == null) {
            ACME_ErrorHandler.handleError('Invalid input: Numbers cannot be null');
        }
        
        if (num2 == 0) {
            ACME_ErrorHandler.handleError('Division by zero is not allowed');
        }
        
        Decimal result = num1 / num2;
        saveCalculationHistory('Division', num1, num2, result);
        return result;
    }
    
    /**
     * Save calculation history to custom object
     * @param operationType Type of mathematical operation
     * @param num1 First number
     * @param num2 Second number
     * @param result Calculation result
     */
    private static void saveCalculationHistory(String operationType, Decimal num1, Decimal num2, Decimal result) {
        if (!Schema.sObjectType.ACME_Calculation_History__c.isCreateable()) {
            ACME_ErrorHandler.handleError('No permission to create Calculation History');
        }
        
        ACME_Calculation_History__c history = new ACME_Calculation_History__c(
            ACME_Operation_Type__c = operationType,
            ACME_First_Number__c = num1,
            ACME_Second_Number__c = num2,
            ACME_Result__c = result,
            ACME_Timestamp__c = System.now()
        );
        
        try {
            insert history;
        } catch (Exception e) {
            ACME_ErrorHandler.logError('Error saving calculation history: ' + e.getMessage());
        }
    }
}