/**
 * Test class for ACME_CalculatorService
 * @author Acme Development Team
 * @date 2024-02-15
 */
@isTest
private class ACME_CalculatorServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Optional test setup if needed
    }

    @isTest
    static void testAddOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.add(5, 3);
        Test.stopTest();

        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Addition'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(5, histories[0].FirstOperand__c, 'First operand should match');
        System.assertEquals(3, histories[0].SecondOperand__c, 'Second operand should match');
        System.assertEquals(8, histories[0].Result__c, 'Result should match');
    }

    @isTest
    static void testSubtractOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Subtraction'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(10, histories[0].FirstOperand__c, 'First operand should match');
        System.assertEquals(4, histories[0].SecondOperand__c, 'Second operand should match');
        System.assertEquals(6, histories[0].Result__c, 'Result should match');
    }

    @isTest
    static void testMultiplyOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.multiply(5, 6);
        Test.stopTest();

        System.assertEquals(30, result, 'Multiplication should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Multiplication'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(5, histories[0].FirstOperand__c, 'First operand should match');
        System.assertEquals(6, histories[0].SecondOperand__c, 'Second operand should match');
        System.assertEquals(30, histories[0].Result__c, 'Result should match');
    }

    @isTest
    static void testDivideOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.divide(15, 3);
        Test.stopTest();

        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Division'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(15, histories[0].FirstOperand__c, 'First operand should match');
        System.assertEquals(3, histories[0].SecondOperand__c, 'Second operand should match');
        System.assertEquals(5, histories[0].Result__c, 'Result should match');
    }

    @isTest
    static void testDivideByZeroException() {
        Test.startTest();
        try {
            ACME_CalculatorService.divide(10, 0);
            System.assert(false, 'Divide by zero should throw an exception');
        } catch (DivideByZeroException e) {
            System.assert(true, 'Divide by zero exception was thrown');
        }
        Test.stopTest();
    }
}