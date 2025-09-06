public class ACME_LeadScoringService {
    public static Decimal calculateLeadScore(Lead leadRecord) {
        Decimal score = 0;

        // Check Number of Employees
        if (leadRecord.Number_of_Employees__c != null) {
            if (leadRecord.Number_of_Employees__c <= 10) {
                score += 1;
            } else if (leadRecord.Number_of_Employees__c <= 50) {
                score += 2;
            } else if (leadRecord.Number_of_Employees__c <= 100) {
                score += 3;
            } else {
                score += 4;
            }
        }

        // Add more scoring criteria as needed
        return score;
    }
}