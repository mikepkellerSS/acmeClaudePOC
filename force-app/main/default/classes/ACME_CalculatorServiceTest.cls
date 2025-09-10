@isTest
private class ACME_CalculatorServiceTest {
    
    @isTest
    static void testAddOperation() {
        Decimal result = ACME_CalculatorService.calculate(5, 3, ACME_CalculatorService.MathOperation.ADD);
        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__Operation__c, ACME__Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__Operation__c = 'ADD'
        ];
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
    }

    @isTest
    static void testSubtractOperation() {
        Decimal result = ACME_CalculatorService.calculate(10, 4, ACME_CalculatorService.MathOperation.SUBTRACT);
        System.assertEquals(6, result, 'Subtraction should return correct result');
    }

    @isTest
    static void testMultiplyOperation() {
        Decimal result = ACME_CalculatorService.calculate(5, 6, ACME_CalculatorService.MathOperation.MULTIPLY);
        System.assertEquals(30, result, 'Multiplication should return correct result');
    }

    @isTest
    static void testDivideOperation() {
        Decimal result = ACME_CalculatorService.calculate(15, 3, ACME_CalculatorService.MathOperation.DIVIDE);
        System.assertEquals(5, result, 'Division should return correct result');
    }

    @isTest
    static void testDivisionByZero() {
        try {
            ACME_CalculatorService.calculate(10, 0, ACME_CalculatorService.MathOperation.DIVIDE);
            System.assert(false, 'Division by zero should throw an exception');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Division by zero'), 'Correct exception should be thrown');
        }
    }
}