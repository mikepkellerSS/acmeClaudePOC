public class ACMELeadScoringService {
    public static List<ACME_Scoring_Configuration__mdt> getScoringConfigurations() {
        return [
            SELECT MasterLabel, ACME_Weight__c 
            FROM ACME_Scoring_Configuration__mdt
        ];
    }

    public static Decimal calculateLeadScore(Lead leadRecord) {
        List<ACME_Scoring_Configuration__mdt> scoringConfigs = getScoringConfigurations();
        Decimal totalScore = 0;

        for (ACME_Scoring_Configuration__mdt config : scoringConfigs) {
            // Example scoring logic
            if (config.MasterLabel == 'Number of Employees') {
                totalScore += calculateEmployeeScore(leadRecord.Number_of_Employees__c, config.ACME_Weight__c);
            }
            // Add more scoring criteria as needed
        }

        return totalScore;
    }

    private static Decimal calculateEmployeeScore(Decimal numberOfEmployees, Decimal weight) {
        if (numberOfEmployees == null || weight == null) return 0;
        
        // Example scoring calculation
        if (numberOfEmployees <= 10) {
            return 1 * weight;
        } else if (numberOfEmployees <= 50) {
            return 2 * weight;
        } else if (numberOfEmployees <= 100) {
            return 3 * weight;
        } else {
            return 4 * weight;
        }
    }
}