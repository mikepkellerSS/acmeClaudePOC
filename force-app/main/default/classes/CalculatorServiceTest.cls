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
        
        List<CalculationHistory__c> history = [SELECT FirstOperand__c, SecondOperand__c, Operation__c, Result__c FROM CalculationHistory__c WHERE Operation__c = 'Addition'];
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
        
        List<CalculationHistory__c> history = [SELECT Operation__c, Result__c FROM CalculationHistory__c WHERE Operation__c = 'Subtraction'];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals(7, history[0].Result__c, 'Result should be 7');
    }
    
    @isTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = CalculatorService.multiply(4, 6);
        Test.stopTest();
        
        System.assertEquals(24, result, 'Multiplication result should be 24');
        
        List<CalculationHistory__c> history = [SELECT Operation__c, Result__c FROM CalculationHistory__c WHERE Operation__c = 'Multiplication'];
        System.assertEquals(1, history.size(), 'Should have one history record');
        System.assertEquals(24, history[0].Result__c, 'Result should be 24');
    }
    
    @isTest
    static void testDivision() {
        Test.startTest();
        Decimal result = CalculatorService.divide(20, 4);
        Test.stopTest();
        
        System.assertEquals(5, result, 'Division result should be 5');
        
        List<CalculationHistory__c> history = [SELECT Operation__c, Result__c FROM CalculationHistory__c WHERE Operation__c = 'Division'];
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
            System.assert(e.getMessage().contains('Division by zero'), 'Should throw division by zero exception');
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
        List<CalculationHistory__c> history = CalculatorService.getCalculationHistory(10);
        Test.stopTest();
        
        System.assertEquals(3, history.size(), 'Should return 3 history records');
        // Verify records are ordered by CreatedDate DESC
        System.assertEquals('Multiplication', history[0].Operation__c, 'First record should be the most recent (Multiplication)');
    }
    
    @isTest
    static void testDecimalOperations() {
        Test.startTest();
        Decimal result1 = CalculatorService.add(10.5, 5.25);
        Decimal result2 = CalculatorService.multiply(2.5, 4.2);
        Test.stopTest();
        
        System.assertEquals(15.75, result1, 'Decimal addition should work correctly');
        System.assertEquals(10.50, result2, 'Decimal multiplication should work correctly');
    }
    
    @isTest
    static void testNegativeNumbers() {
        Test.startTest();
        Decimal result1 = CalculatorService.add(-5, 3);
        Decimal result2 = CalculatorService.subtract(10, -5);
        Test.stopTest();
        
        System.assertEquals(-2, result1, 'Addition with negative numbers should work');
        System.assertEquals(15, result2, 'Subtraction with negative numbers should work');
    }
}