public with sharing class CalculatorController {
    
    /**
     * Wrapper class for calculation requests
     */
    public class CalculationRequest {
        @AuraEnabled public Decimal firstOperand { get; set; }
        @AuraEnabled public Decimal secondOperand { get; set; }
        @AuraEnabled public String operation { get; set; }
    }
    
    /**
     * Wrapper class for calculation responses
     */
    public class CalculationResponse {
        @AuraEnabled public Boolean success { get; set; }
        @AuraEnabled public Decimal result { get; set; }
        @AuraEnabled public String errorMessage { get; set; }
        
        public CalculationResponse(Boolean success, Decimal result, String errorMessage) {
            this.success = success;
            this.result = result;
            this.errorMessage = errorMessage;
        }
    }
    
    /**
     * Performs calculation based on the request
     * @param request CalculationRequest containing operands and operation
     * @return CalculationResponse with result or error
     */
    @AuraEnabled
    public static CalculationResponse performCalculation(CalculationRequest request) {
        try {
            if (request == null) {
                return new CalculationResponse(false, null, 'Invalid request');
            }
            
            if (request.firstOperand == null || request.secondOperand == null) {
                return new CalculationResponse(false, null, 'Both operands are required');
            }
            
            if (String.isBlank(request.operation)) {
                return new CalculationResponse(false, null, 'Operation is required');
            }
            
            Decimal result;
            String operation = request.operation.toUpperCase();
            
            switch on operation {
                when 'ADD', 'ADDITION', '+' {
                    result = CalculatorService.add(request.firstOperand, request.secondOperand);
                }
                when 'SUBTRACT', 'SUBTRACTION', '-' {
                    result = CalculatorService.subtract(request.firstOperand, request.secondOperand);
                }
                when 'MULTIPLY', 'MULTIPLICATION', '*' {
                    result = CalculatorService.multiply(request.firstOperand, request.secondOperand);
                }
                when 'DIVIDE', 'DIVISION', '/' {
                    result = CalculatorService.divide(request.firstOperand, request.secondOperand);
                }
                when else {
                    return new CalculationResponse(false, null, 'Unsupported operation: ' + request.operation);
                }
            }
            
            return new CalculationResponse(true, result, null);
            
        } catch (IllegalArgumentException e) {
            return new CalculationResponse(false, null, e.getMessage());
        } catch (Exception e) {
            return new CalculationResponse(false, null, 'An unexpected error occurred: ' + e.getMessage());
        }
    }
    
    /**
     * Retrieves calculation history
     * @param limitCount Number of records to retrieve
     * @return List of calculation history records
     */
    @AuraEnabled(cacheable=true)
    public static List<CalculationHistory__c> getCalculationHistory(Integer limitCount) {
        try {
            return CalculatorService.getCalculationHistory(limitCount);
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving calculation history: ' + e.getMessage());
        }
    }
    
    /**
     * Clears all calculation history
     * @return Number of records deleted
     */
    @AuraEnabled
    public static Integer clearCalculationHistory() {
        try {
            return CalculatorService.clearCalculationHistory();
        } catch (Exception e) {
            throw new AuraHandledException('Error clearing calculation history: ' + e.getMessage());
        }
    }
    
    /**
     * Performs simple addition (convenience method)
     * @param a First operand
     * @param b Second operand
     * @return Sum of a and b
     */
    @AuraEnabled
    public static Decimal add(Decimal a, Decimal b) {
        try {
            return CalculatorService.add(a, b);
        } catch (Exception e) {
            throw new AuraHandledException('Error performing addition: ' + e.getMessage());
        }
    }
    
    /**
     * Performs simple subtraction (convenience method)
     * @param a First operand
     * @param b Second operand
     * @return Difference of a and b
     */
    @AuraEnabled
    public static Decimal subtract(Decimal a, Decimal b) {
        try {
            return CalculatorService.subtract(a, b);
        } catch (Exception e) {
            throw new AuraHandledException('Error performing subtraction: ' + e.getMessage());
        }
    }
    
    /**
     * Performs simple multiplication (convenience method)
     * @param a First operand
     * @param b Second operand
     * @return Product of a and b
     */
    @AuraEnabled
    public static Decimal multiply(Decimal a, Decimal b) {
        try {
            return CalculatorService.multiply(a, b);
        } catch (Exception e) {
            throw new AuraHandledException('Error performing multiplication: ' + e.getMessage());
        }
    }
    
    /**
     * Performs simple division (convenience method)
     * @param a First operand
     * @param b Second operand
     * @return Quotient of a divided by b
     */
    @AuraEnabled
    public static Decimal divide(Decimal a, Decimal b) {
        try {
            return CalculatorService.divide(a, b);
        } catch (Exception e) {
            throw new AuraHandledException('Error performing division: ' + e.getMessage());
        }
    }
}