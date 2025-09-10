/**
 * @description Test class for ACME_HelloWorldService
 * @author Studio Science
 * @date 2025-09-10
 */
@IsTest
private class ACME_HelloWorldServiceTest {
    
    @IsTest
    static void testSayHello() {
        // Use Test Data Factory pattern
        Test.startTest();
        ACME_HelloWorldService service = new ACME_HelloWorldService();
        String result = service.sayHello();
        
        System.assert(
            String.isNotBlank(result), 
            'Hello World message should not be blank'
        );
        Test.stopTest();
    }

    @IsTest
    static void testAcmeException() {
        ACME_HelloWorldService.AcmeException testException = 
            new ACME_HelloWorldService.AcmeException('Test exception');
        
        System.assertNotEquals(
            null, 
            testException, 
            'Custom exception should be instantiable'
        );
    }
}