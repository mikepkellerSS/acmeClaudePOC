/**
 * @description Test class for ACME Calculator Service
 * @author Studio Science
 * @date 2024-03-15
 */
@isTest
private class ACME_CalculatorServiceTest {
    
    /**
     * Test addition operation
     */
    @isTest
    static void testAddOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.add(5, 3);
        Test.stopTest();
        
        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_Calculation_History__c> histories = ACME_CalculatorSelector.getCalculationHistory(1);
        System.assertEquals(1, histories.size(), 'Calculation history should be saved');
        System.assertEquals('Addition', histories[0].ACME_Operation_Type__c, 'Operation type should be Addition');
    }
    
    /**
     * Test subtraction operation
     */
    @isTest
    static void testSubtractOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.subtract(10, 4);
        Test.stopTest();
        
        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_Calculation_History__c> histories = ACME_CalculatorSelector.getCalculationHistory(1);
        System.assertEquals(1, histories.size(), 'Calculation history should be saved');
        System.assertEquals('Subtraction', histories[0].ACME_Operation_Type__c, 'Operation type should be Subtraction');
    }
    
    /**
     * Test multiplication operation
     */
    @isTest
    static void testMultiplyOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.multiply(5, 6);
        Test.stopTest();
        
        System.assertEquals(30, result, 'Multiplication should return correct result');
        
        List<ACME_Calculation_History__c> histories = ACME_CalculatorSelector.getCalculationHistory(1);
        System.assertEquals(1, histories.size(), 'Calculation history should be saved');
        System.assertEquals('Multiplication', histories[0].ACME_Operation_Type__c, 'Operation type should be Multiplication');
    }
    
    /**
     * Test division operation
     */
    @isTest
    static void testDivideOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.divide(15, 3);
        Test.stopTest();
        
        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_Calculation_History__c> histories = ACME_CalculatorSelector.getCalculationHistory(1);
        System.assertEquals(1, histories.size(), 'Calculation history should be saved');
        System.assertEquals('Division', histories[0].ACME_Operation_Type__c, 'Operation type should be Division');
    }
    
    /**
     * Test null input handling
     */
    @isTest
    static void testNullInputHandling() {
        Test.startTest();
        try {
            ACME_CalculatorService.add(null, 5);
            System.assert(false, 'Should have thrown an exception');
        } catch (ACME_ErrorHandler.CalculatorException e) {
            System.assertEquals('Invalid input: Numbers cannot be null', e.getMessage(), 'Error message should match');
        }
        Test.stopTest();
    }
    
    /**
     * Test division by zero
     */
    @isTest
    static void testDivisionByZero() {
        Test.startTest();
        try {
            ACME_CalculatorService.divide(10, 0);
            System.assert(false, 'Should have thrown an exception');
        } catch (ACME_ErrorHandler.CalculatorException e) {
            System.assertEquals('Division by zero is not allowed', e.getMessage(), 'Error message should match');
        }
        Test.stopTest();
    }
}