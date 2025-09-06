@isTest
private class AccountTriggerHandlerTest {
    @isTest
    static void testAccountNameValidation_Insert() {
        Account testAccount = new Account(Name = '');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testAccount, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Account insert should fail');
        System.assert(result.getErrors()[0].getMessage().contains('Account Name is required'), 'Error message should indicate name is required');
    }
    
    @isTest
    static void testAccountNameValidation_Update() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        testAccount.Name = '';
        
        Test.startTest();
        Database.SaveResult result = Database.update(testAccount, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Account update should fail');
        System.assert(result.getErrors()[0].getMessage().contains('Account Name is required'), 'Error message should indicate name is required');
    }
    
    @isTest
    static void testAccountNameValidation_Success() {
        Account testAccount = new Account(Name = 'Valid Account');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testAccount, false);
        Test.stopTest();
        
        System.assert(result.isSuccess(), 'Account insert should succeed');
    }
}