@isTest
public class CalculatorServiceTest {
    
    @testSetup
    static void setupTestData() {
        // Clean up any existing test data
        delete [SELECT Id FROM CalculationHistory__c];
    }
    
    @isTest
    static void testAddition() {
        Test.startTest();
        Decimal result = CalculatorService.add(10, 5);
        Test.stopTest();
        
        System.assertEquals(15, result, 'Addition result should be 15');
        
        // Verify history was saved
        List<CalculationHistory__c> history = [SELECT FirstOperand__c, SecondOperand__c, Operation__c, Result__c FROM CalculationHistory__c];
        System.assertEquals(1, history.size(), 'One history record should be created');
        System.assertEquals(10, history[0].FirstOperand__c, 'First operand should be 10');
        System.assertEquals(5, history[0].SecondOperand__c, 'Second operand should be 5');
        System.assertEquals('ADD', history[0].Operation__c, 'Operation should be ADD');
        System.assertEquals(15, history[0].Result__c, 'Result should be 15');
    }
    
    @isTest
    static void testSubtraction() {
        Test.startTest();
        Decimal result = CalculatorService.subtract(10, 3);
        Test.stopTest();
        
        System.assertEquals(7, result, 'Subtraction result should be 7');
        
        // Verify history was saved
        List<CalculationHistory__c> history = [SELECT FirstOperand__c, SecondOperand__c, Operation__c, Result__c FROM CalculationHistory__c];
        System.assertEquals(1, history.size(), 'One history record should be created');
        System.assertEquals(10, history[0].FirstOperand__c, 'First operand should be 10');
        System.assertEquals(3, history[0].SecondOperand__c, 'Second operand should be 3');
        System.assertEquals('SUBTRACT', history[0].Operation__c, 'Operation should be SUBTRACT');
        System.assertEquals(7, history[0].Result__c, 'Result should be 7');
    }
    
    @isTest
    static void testMultiplication() {
        Test.startTest();
        Decimal result = CalculatorService.multiply(4, 6);
        Test.stopTest();
        
        System.assertEquals(24, result, 'Multiplication result should be 24');
        
        // Verify history was saved
        List<CalculationHistory__c> history = [SELECT FirstOperand__c, SecondOperand__c, Operation__c, Result__c FROM CalculationHistory__c];
        System.assertEquals(1, history.size(), 'One history record should be created');
        System.assertEquals(4, history[0].FirstOperand__c, 'First operand should be 4');
        System.assertEquals(6, history[0].SecondOperand__c, 'Second operand should be 6');
        System.assertEquals('MULTIPLY', history[0].Operation__c, 'Operation should be MULTIPLY');
        System.assertEquals(24, history[0].Result__c, 'Result should be 24');
    }
    
    @isTest
    static void testDivision() {
        Test.startTest();
        Decimal result = CalculatorService.divide(20, 4);
        Test.stopTest();
        
        System.assertEquals(5, result, 'Division result should be 5');
        
        // Verify history was saved
        List<CalculationHistory__c> history = [SELECT FirstOperand__c, SecondOperand__c, Operation__c, Result__c FROM CalculationHistory__c];
        System.assertEquals(1, history.size(), 'One history record should be created');
        System.assertEquals(20, history[0].FirstOperand__c, 'First operand should be 20');
        System.assertEquals(4, history[0].SecondOperand__c, 'Second operand should be 4');
        System.assertEquals('DIVIDE', history[0].Operation__c, 'Operation should be DIVIDE');
        System.assertEquals(5, history[0].Result__c, 'Result should be 5');
    }
    
    @isTest
    static void testDivisionByZero() {
        Test.startTest();
        try {
            CalculatorService.divide(10, 0);
            System.assert(false, 'Exception should have been thrown for division by zero');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Division by zero is not allowed', e.getMessage(), 'Correct exception message should be thrown');
        }
        Test.stopTest();
        
        // Verify no history was saved for failed operation
        List<CalculationHistory__c> history = [SELECT Id FROM CalculationHistory__c];
        System.assertEquals(0, history.size(), 'No history record should be created for failed operation');
    }
    
    @isTest
    static void testGetCalculationHistory() {
        // Create test data
        List<CalculationHistory__c> testHistory = new List<CalculationHistory__c>();
        for (Integer i = 0; i < 5; i++) {
            testHistory.add(new CalculationHistory__c(
                FirstOperand__c = i,
                SecondOperand__c = i + 1,
                Operation__c = 'ADD',
                Result__c = i + (i + 1)
            ));
        }
        insert testHistory;
        
        Test.startTest();
        List<CalculationHistory__c> result = CalculatorService.getCalculationHistory();
        Test.stopTest();
        
        System.assertEquals(5, result.size(), 'Should return 5 history records');
        // Verify records are ordered by CreatedDate DESC
        System.assert(result[0].CreatedDate >= result[4].CreatedDate, 'Records should be ordered by CreatedDate DESC');
    }
    
    @isTest
    static void testGetCalculationHistoryWithLimit() {
        // Create test data
        List<CalculationHistory__c> testHistory = new List<CalculationHistory__c>();
        for (Integer i = 0; i < 10; i++) {
            testHistory.add(new CalculationHistory__c(
                FirstOperand__c = i,
                SecondOperand__c = i + 1,
                Operation__c = 'ADD',
                Result__c = i + (i + 1)
            ));
        }
        insert testHistory;
        
        Test.startTest();
        List<CalculationHistory__c> result = CalculatorService.getCalculationHistory(3);
        Test.stopTest();
        
        System.assertEquals(3, result.size(), 'Should return only 3 history records when limit is specified');
    }
    
    @isTest
    static void testClearCalculationHistory() {
        // Create test data
        List<CalculationHistory__c> testHistory = new List<CalculationHistory__c>();
        for (Integer i = 0; i < 3; i++) {
            testHistory.add(new CalculationHistory__c(
                FirstOperand__c = i,
                SecondOperand__c = i + 1,
                Operation__c = 'ADD',
                Result__c = i + (i + 1)
            ));
        }
        insert testHistory;
        
        Test.startTest();
        Integer deletedCount = CalculatorService.clearCalculationHistory();
        Test.stopTest();
        
        System.assertEquals(3, deletedCount, 'Should return count of deleted records');
        
        // Verify all records were deleted
        List<CalculationHistory__c> remainingHistory = [SELECT Id FROM CalculationHistory__c];
        System.assertEquals(0, remainingHistory.size(), 'All history records should be deleted');
    }
    
    @isTest
    static void testDecimalOperations() {
        Test.startTest();
        Decimal addResult = CalculatorService.add(10.5, 5.25);
        Decimal subtractResult = CalculatorService.subtract(10.75, 3.25);
        Decimal multiplyResult = CalculatorService.multiply(2.5, 4.2);
        Decimal divideResult = CalculatorService.divide(15.6, 3.2);
        Test.stopTest();
        
        System.assertEquals(15.75, addResult, 'Decimal addition should work correctly');
        System.assertEquals(7.5, subtractResult, 'Decimal subtraction should work correctly');
        System.assertEquals(10.5, multiplyResult, 'Decimal multiplication should work correctly');
        System.assertEquals(4.875, divideResult, 'Decimal division should work correctly');
        
        // Verify all operations were saved to history
        List<CalculationHistory__c> history = [SELECT Id FROM CalculationHistory__c];
        System.assertEquals(4, history.size(), 'All four operations should be saved to history');
    }
}