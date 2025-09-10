/**
 * @description Demonstrates intentional compilation challenges
 * @author Studio Science
 * @date 2025-09-10
 */
public class ACME_BadCodeGenerator {
    
    // Intentional compilation error: Unresolved reference
    private NonExistentType invalidField;
    
    /**
     * Method designed to cause compilation error
     */
    public void generateBadCode() {
        // Intentional compilation error: Undefined method
        this.undefinedMethod();
    }
}