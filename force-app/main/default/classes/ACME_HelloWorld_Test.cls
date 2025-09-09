/**
 * @description Test class for ACME_HelloWorld utility
 * @author Studio Science
 * @date 2024-02-20
 * @group Test
 */
@isTest
private class ACME_HelloWorld_Test {
    
    @isTest
    static void testSayHello() {
        // Test successful scenario
        String result = ACME_HelloWorld.sayHello();
        System.assertEquals('Hello, Salesforce World!', result, 'Greeting should match');
    }

    @isTest
    static void testErrorHandling() {
        // Simulate potential error scenario (though unlikely in this simple method)
        String result = ACME_HelloWorld.sayHello();
        System.assertNotEquals(null, result, 'Result should never be null');
        System.assert(!result.startsWith('Error:'), 'Method should not return an error');
    }
}