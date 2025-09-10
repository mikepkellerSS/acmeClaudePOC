/**
 * @description Demonstrates intentional compilation error scenarios
 * @author Studio Science
 * @date 2025-09-10
 */
public with sharing class ACME_BadCodeGenerator {
    
    /**
     * Intentionally generates bad code with compilation errors
     * @throws UndefinedMethodException Demonstrates an intentional compilation error
     */
    public void generateBadCode() {
        // Intentional compilation error: Undefined method reference
        String result = undefinedMethod(); // This will cause a compilation error
    }

    /**
     * Demonstrates a method with potential type mismatch
     * @param input String input to process
     * @return Integer calculated value (intentionally incorrect)
     */
    private Integer calculateValue(String input) {
        // Potential type mismatch intentionally introduced
        return input.length(); // This could cause compilation issues
    }
}