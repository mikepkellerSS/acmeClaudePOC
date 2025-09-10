@isTest
public class CalculatorServiceTest {
    
    @testSetup
    static void setupTestData() {
        // Clean up any existing test data
        delete [SELECT Id FROM CalculationHistory__c WHERE Operation__c != null];
    }
    
    @isTest
    static void testAddition() {
        Test.startTest();
        Decimal result = CalculatorService.add(10, 5);
        Test.stopTest();
        
        System.assertEquals(15, result, 'Addition result should be 15');
        
        List<CalculationHistory__c> history = [
            SELECT FirstOperand__c, SecondOperand__c, Operation__c, Result__c 
            FROM CalculationHistory__c 
            WHERE Operation__c = 'ADD'
        ];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals(10, history[0].FirstOperand__c, 'First operand should be 10');
        System.assertEquals(5, history[0].SecondOperand__c, 'Second operand should be 5');
        System.assertEquals(15, history[0].Result__c, 'Result should be 15');
    }
    
    @isTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = CalculatorService.subtract(10, 3);
        Test.stopTest();
        
        System.assertEquals(7, result, 'Subtraction result should be 7');
        
        List<CalculationHistory__c> history = [
            SELECT Operation__c, Result__c FROM CalculationHistory__c 
            WHERE Operation__c = 'SUBTRACT'
        ];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals(7, history[0].Result__c, 'Result should be 7');
    }
    
    @isTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = CalculatorService.multiply(4, 6);
        Test.stopTest();
        
        System.assertEquals(24, result, 'Multiplication result should be 24');
        
        List<CalculationHistory__c> history = [
            SELECT Operation__c, Result__c FROM CalculationHistory__c 
            WHERE Operation__c = 'MULTIPLY'
        ];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals(24, history[0].Result__c, 'Result should be 24');
    }
    
    @isTest
    static void testDivision() {
        Test.startTest();
        Decimal result = CalculatorService.divide(20, 4);
        Test.stopTest();
        
        System.assertEquals(5, result, 'Division result should be 5');
        
        List<CalculationHistory__c> history = [
            SELECT Operation__c, Result__c FROM CalculationHistory__c 
            WHERE Operation__c = 'DIVIDE'
        ];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals(5, history[0].Result__c, 'Result should be 5');
    }
    
    @isTest
    static void testDivisionByZero() {
        Test.startTest();
        try {
            CalculatorService.divide(10, 0);
            System.assert(false, 'Should have thrown an exception');
        } catch (CalculatorService.CalculatorException e) {
            System.assertEquals('Division by zero is not allowed', e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void testPower() {
        Test.startTest();
        Decimal result = CalculatorService.power(2, 3);
        Test.stopTest();
        
        System.assertEquals(8, result, 'Power result should be 8');
        
        List<CalculationHistory__c> history = [
            SELECT Operation__c FROM CalculationHistory__c 
            WHERE Operation__c = 'POWER'
        ];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals('POWER', history[0].Operation__c, 'Operation should be POWER');
    }
    
    @isTest
    static void testSquareRoot() {
        Test.startTest();
        Decimal result = CalculatorService.squareRoot(16);
        Test.stopTest();
        
        System.assertEquals(4, result, 'Square root result should be 4');
        
        List<CalculationHistory__c> history = [
            SELECT Operation__c FROM CalculationHistory__c 
            WHERE Operation__c = 'SQRT'
        ];
        System.assertEquals(1, history.size(), 'Should have one history record');
    }
    
    @isTest
    static void testSquareRootNegative() {
        Test.startTest();
        try {
            CalculatorService.squareRoot(-4);
            System.assert(false, 'Should have thrown an exception');
        } catch (CalculatorService.CalculatorException e) {
            System.assertEquals('Square root of negative number is not allowed', e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetCalculationHistory() {
        // Create test data
        CalculatorService.add(1, 2);
        CalculatorService.subtract(5, 3);
        CalculatorService.multiply(2, 4);
        
        Test.startTest();
        List<CalculationHistory__c> history = CalculatorService.getCalculationHistory(2);
        Test.stopTest();
        
        System.assertEquals(2, history.size(), 'Should return 2 records');
        // Results should be ordered by CreatedDate DESC
        System.assertEquals('MULTIPLY', history[0].Operation__c, 'First record should be MULTIPLY');
        System.assertEquals('SUBTRACT', history[1].Operation__c, 'Second record should be SUBTRACT');
    }
    
    @isTest
    static void testClearHistory() {
        // Create test data
        CalculatorService.add(1, 2);
        CalculatorService.subtract(5, 3);
        
        System.assertEquals(2, [SELECT COUNT() FROM CalculationHistory__c], 'Should have 2 records before clear');
        
        Test.startTest();
        CalculatorService.clearHistory();
        Test.stopTest();
        
        System.assertEquals(0, [SELECT COUNT() FROM CalculationHistory__c], 'Should have 0 records after clear');
    }
}