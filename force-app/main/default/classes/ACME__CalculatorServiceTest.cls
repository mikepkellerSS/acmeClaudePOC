@IsTest
private class ACME__CalculatorServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Optional: Create any necessary test setup data
    }

    @IsTest
    static void testAddition() {
        Test.startTest();
        Decimal result = ACME__CalculatorService.add(5, 3);
        Test.stopTest();

        System.assertEquals(8, result, 'Addition should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__Operation__c, ACME__FirstOperand__c, ACME__SecondOperand__c, ACME__Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__Operation__c = 'Addition'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(5, histories[0].ACME__FirstOperand__c, 'First operand should be recorded');
        System.assertEquals(3, histories[0].ACME__SecondOperand__c, 'Second operand should be recorded');
        System.assertEquals(8, histories[0].ACME__Result__c, 'Result should be recorded');
    }

    @IsTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = ACME__CalculatorService.subtract(10, 4);
        Test.stopTest();

        System.assertEquals(6, result, 'Subtraction should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__Operation__c, ACME__FirstOperand__c, ACME__SecondOperand__c, ACME__Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__Operation__c = 'Subtraction'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(10, histories[0].ACME__FirstOperand__c, 'First operand should be recorded');
        System.assertEquals(4, histories[0].ACME__SecondOperand__c, 'Second operand should be recorded');
        System.assertEquals(6, histories[0].ACME__Result__c, 'Result should be recorded');
    }

    @IsTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = ACME__CalculatorService.multiply(6, 7);
        Test.stopTest();

        System.assertEquals(42, result, 'Multiplication should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__Operation__c, ACME__FirstOperand__c, ACME__SecondOperand__c, ACME__Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__Operation__c = 'Multiplication'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(6, histories[0].ACME__FirstOperand__c, 'First operand should be recorded');
        System.assertEquals(7, histories[0].ACME__SecondOperand__c, 'Second operand should be recorded');
        System.assertEquals(42, histories[0].ACME__Result__c, 'Result should be recorded');
    }

    @IsTest
    static void testDivision() {
        Test.startTest();
        Decimal result = ACME__CalculatorService.divide(15, 3);
        Test.stopTest();

        System.assertEquals(5, result, 'Division should return correct result');
        
        List<ACME_CalculationHistory__c> histories = [
            SELECT ACME__Operation__c, ACME__FirstOperand__c, ACME__SecondOperand__c, ACME__Result__c 
            FROM ACME_CalculationHistory__c 
            WHERE ACME__Operation__c = 'Division'
        ];
        
        System.assertEquals(1, histories.size(), 'Calculation history should be created');
        System.assertEquals(15, histories[0].ACME__FirstOperand__c, 'First operand should be recorded');
        System.assertEquals(3, histories[0].ACME__SecondOperand__c, 'Second operand should be recorded');
        System.assertEquals(5, histories[0].ACME__Result__c, 'Result should be recorded');
    }

    @IsTest
    static void testDivisionByZero() {
        Test.startTest();
        try {
            ACME__CalculatorService.divide(10, 0);
            System.assert(false, 'Division by zero should throw an exception');
        } catch (ACME__CalculatorService.ACME__CalculatorException e) {
            System.assert(true, 'Division by zero exception caught');
        }
        Test.stopTest();
    }
}