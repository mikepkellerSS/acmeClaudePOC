@isTest
private class AccountTriggerHandlerTest {
    @isTest
    static void testAccountValidation_NameRequired() {
        Account testAccount = new Account(Name = '');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testAccount, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Account insert should fail');
        System.assert(result.getErrors()[0].getMessage().contains('Account Name is required'), 'Error message should indicate name is required');
    }
    
    @isTest
    static void testAccountValidation_NegativeAnnualRevenue() {
        Account testAccount = new Account(Name = 'Test Account', AnnualRevenue = -1000);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testAccount, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Account insert should fail');
        System.assert(result.getErrors()[0].getMessage().contains('Annual Revenue cannot be negative'), 'Error message should indicate negative revenue is invalid');
    }
    
    @isTest
    static void testAccountValidation_ValidAccount() {
        Account testAccount = new Account(Name = 'Valid Account', AnnualRevenue = 1000);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(testAccount, false);
        Test.stopTest();
        
        System.assert(result.isSuccess(), 'Account insert should succeed');
    }
}