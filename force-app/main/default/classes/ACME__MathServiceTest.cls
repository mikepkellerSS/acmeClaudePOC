@isTest
private class ACME__MathServiceTest {
    @TestSetup
    static void setupTestData() {
        // Optional: Create any necessary test setup data
    }

    @isTest
    static void testAddition() {
        Test.startTest();
        Decimal result = ACME__MathService.add(5, 3);
        Test.stopTest();

        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = ACME__CalculationHistorySelector.selectByOperation('Addition');
        System.assertNotEquals(0, histories.size(), 'Calculation history should be logged');
        System.assertEquals(5, histories[0].ACME__FirstOperand__c, 'First operand should be logged correctly');
        System.assertEquals(3, histories[0].ACME__SecondOperand__c, 'Second operand should be logged correctly');
        System.assertEquals(8, histories[0].ACME__Result__c, 'Result should be logged correctly');
    }

    @isTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = ACME__MathService.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_CalculationHistory__c> histories = ACME__CalculationHistorySelector.selectByOperation('Subtraction');
        System.assertNotEquals(0, histories.size(), 'Calculation history should be logged');
    }

    @isTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = ACME__MathService.multiply(5, 6);
        Test.stopTest();

        System.assertEquals(30, result, 'Multiplication should return correct result');
        
        List<ACME_CalculationHistory__c> histories = ACME__CalculationHistorySelector.selectByOperation('Multiplication');
        System.assertNotEquals(0, histories.size(), 'Calculation history should be logged');
    }

    @isTest
    static void testDivision() {
        Test.startTest();
        Decimal result = ACME__MathService.divide(15, 3);
        Test.stopTest();

        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_CalculationHistory__c> histories = ACME__CalculationHistorySelector.selectByOperation('Division');
        System.assertNotEquals(0, histories.size(), 'Calculation history should be logged');
    }

    @isTest
    static void testDivideByZero() {
        Test.startTest();
        try {
            ACME__MathService.divide(10, 0);
            System.assert(false, 'Divide by zero should throw an exception');
        } catch (DivideByZeroException e) {
            System.assert(true, 'Divide by zero exception was thrown');
        }
        Test.stopTest();
    }
}