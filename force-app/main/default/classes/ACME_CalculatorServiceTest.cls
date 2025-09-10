@IsTest
private class ACME_CalculatorServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Optional test setup if needed
    }

    @IsTest
    static void testAddition() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.add(5, 3);
        Test.stopTest();

        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationHistoryNumber__c, ACME__CalculationType__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Addition'
        ];
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(8, histories[0].ACME__CalculationHistoryNumber__c, 'Calculation result should be stored');
    }

    @IsTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationHistoryNumber__c, ACME__CalculationType__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Subtraction'
        ];
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(6, histories[0].ACME__CalculationHistoryNumber__c, 'Calculation result should be stored');
    }

    @IsTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.multiply(5, 6);
        Test.stopTest();

        System.assertEquals(30, result, 'Multiplication should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationHistoryNumber__c, ACME__CalculationType__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Multiplication'
        ];
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(30, histories[0].ACME__CalculationHistoryNumber__c, 'Calculation result should be stored');
    }

    @IsTest
    static void testDivision() {
        Test.startTest();
        Decimal result = ACME_CalculatorService.divide(15, 3);
        Test.stopTest();

        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationHistoryNumber__c, ACME__CalculationType__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Division'
        ];
        System.assertEquals(1, histories.size(), 'Calculation history should be logged');
        System.assertEquals(5, histories[0].ACME__CalculationHistoryNumber__c, 'Calculation result should be stored');
    }

    @IsTest
    static void testDivisionByZero() {
        Test.startTest();
        try {
            ACME_CalculatorService.divide(10, 0);
            System.assert(false, 'Should have thrown an exception');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Cannot divide by zero', e.getMessage(), 'Correct error message');
        }
        Test.stopTest();
    }
}