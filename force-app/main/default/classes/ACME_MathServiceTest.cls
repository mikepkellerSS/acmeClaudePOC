@isTest
private class ACME_MathServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Optional test setup if needed
    }

    @isTest
    static void testAddition() {
        Test.startTest();
        Decimal result = ACME_MathService.add(5, 3);
        Test.stopTest();

        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationType__c, ACME__CalculationHistoryNumber__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Addition'
        ];
        System.assertNotEquals(0, histories.size(), 'Calculation history should be created');
    }

    @isTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = ACME_MathService.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationType__c, ACME__CalculationHistoryNumber__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Subtraction'
        ];
        System.assertNotEquals(0, histories.size(), 'Calculation history should be created');
    }

    @isTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = ACME_MathService.multiply(5, 6);
        Test.stopTest();

        System.assertEquals(30, result, 'Multiplication should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationType__c, ACME__CalculationHistoryNumber__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Multiplication'
        ];
        System.assertNotEquals(0, histories.size(), 'Calculation history should be created');
    }

    @isTest
    static void testDivision() {
        Test.startTest();
        Decimal result = ACME_MathService.divide(15, 3);
        Test.stopTest();

        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__CalculationType__c, ACME__CalculationHistoryNumber__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__CalculationType__c = 'Division'
        ];
        System.assertNotEquals(0, histories.size(), 'Calculation history should be created');
    }

    @isTest
    static void testDivisionByZero() {
        Test.startTest();
        try {
            ACME_MathService.divide(10, 0);
            System.assert(false, 'Division by zero should throw an exception');
        } catch (AuraHandledException e) {
            System.assert(true, 'Division by zero correctly handled');
        }
        Test.stopTest();
    }
}