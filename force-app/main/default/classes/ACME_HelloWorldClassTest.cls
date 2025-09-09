/**
 * @description Test class for ACME_HelloWorldClass
 * @author Studio Science
 * @date 2025-09-09
 */
@isTest
private class ACME_HelloWorldClassTest {
    
    @isTest
    static void testSayHello() {
        // Test data factory not needed for this simple scenario
        Test.startTest();
        String result = ACME_HelloWorldClass.sayHello();
        System.assert(
            String.isNotBlank(result), 
            'Hello World method should return a non-blank string'
        );
        Test.stopTest();
    }
}