@isTest
private class ACME_CalculatorServiceTest {
    @isTest
    static void testAddOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.add(5, 3);
        System.assertEquals(8, result, 'Addition should work correctly');
        Test.stopTest();
    }

    @isTest
    static void testSubtractOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.subtract(10, 4);
        System.assertEquals(6, result, 'Subtraction should work correctly');
        Test.stopTest();
    }

    @isTest
    static void testMultiplyOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.multiply(5, 3);
        System.assertEquals(15, result, 'Multiplication should work correctly');
        Test.stopTest();
    }

    @isTest
    static void testDivideOperation() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.divide(10, 2);
        System.assertEquals(5, result, 'Division should work correctly');
        Test.stopTest();
    }

    @isTest
    static void testDivideByZero() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.divide(10, 0);
        System.assertEquals(null, result, 'Division by zero should return null');
        Test.stopTest();
    }

    @isTest
    static void testCalculationHistorySaved() {
        Test.startTest();
        ACME_CalculatorService.add(5, 3);
        List<ACME_CalculationHistory__c> histories = [SELECT Id FROM ACME_CalculationHistory__c];
        System.assert(!histories.isEmpty(), 'Calculation history should be saved');
        Test.stopTest();
    }
}