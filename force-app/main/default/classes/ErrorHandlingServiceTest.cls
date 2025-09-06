@isTest
private class ErrorHandlingServiceTest {
    @isTest
    static void testLogError() {
        Test.startTest();
        try {
            // Intentionally cause an error
            Integer x = 1 / 0;
        } catch (Exception e) {
            ErrorHandlingService.logError(e);
        }
        Test.stopTest();

        List<Error_Log__c> errorLogs = [SELECT Id FROM Error_Log__c];
        System.assert(!errorLogs.isEmpty(), 'Error log should have been created');
    }
}