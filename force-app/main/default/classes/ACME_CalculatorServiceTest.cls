@isTest
private class ACME_CalculatorServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Optional test setup if needed
    }

    @isTest
    static void testAddition() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.add(5, 3);
        Test.stopTest();

        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Addition'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(5, histories[0].FirstOperand__c, 'First operand should be logged correctly');
        System.assertEquals(3, histories[0].SecondOperand__c, 'Second operand should be logged correctly');
        System.assertEquals(8, histories[0].Result__c, 'Result should be logged correctly');
    }

    @isTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Subtraction'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(10, histories[0].FirstOperand__c, 'First operand should be logged correctly');
        System.assertEquals(4, histories[0].SecondOperand__c, 'Second operand should be logged correctly');
        System.assertEquals(6, histories[0].Result__c, 'Result should be logged correctly');
    }

    @isTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.multiply(5, 6);
        Test.stopTest();

        System.assertEquals(30, result, 'Multiplication should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Multiplication'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(5, histories[0].FirstOperand__c, 'First operand should be logged correctly');
        System.assertEquals(6, histories[0].SecondOperand__c, 'Second operand should be logged correctly');
        System.assertEquals(30, histories[0].Result__c, 'Result should be logged correctly');
    }

    @isTest
    static void testDivision() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.divide(15, 3);
        Test.stopTest();

        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT Operation__c, FirstOperand__c, SecondOperand__c, Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE Operation__c = 'Division'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(15, histories[0].FirstOperand__c, 'First operand should be logged correctly');
        System.assertEquals(3, histories[0].SecondOperand__c, 'Second operand should be logged correctly');
        System.assertEquals(5, histories[0].Result__c, 'Result should be logged correctly');
    }

    @isTest
    static void testDivideByZero() {
        Test.startTest();
        try {
            ACME_CalculatorService.divide(10, 0);
            System.assert(false, 'Divide by zero should throw an exception');
        } catch (ACME_CalculatorService.DivideByZeroException e) {
            System.assert(true, 'Divide by zero exception was thrown');
        }
        Test.stopTest();
    }
}