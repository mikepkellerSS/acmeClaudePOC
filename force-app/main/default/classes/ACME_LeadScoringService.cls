/**
 * @description Lead Scoring Service for calculating and managing lead scores
 * @author ACME Development Team
 * @date 2024-02-15
 */
public with sharing class ACME_LeadScoringService {
    
    /**
     * @description Calculate lead score based on multiple criteria
     * @param lead Input lead record to be scored
     * @return Decimal Lead score between 0-100
     */
    public static Decimal calculateLeadScore(Lead lead) {
        // Validate input
        if (lead == null) {
            return 0;
        }

        Decimal totalScore = 0;

        // Retrieve scoring criteria from custom metadata
        List<ACME_Scoring_Criteria__mdt> scoringCriteria = 
            [SELECT DeveloperName, Weight__c, Criteria_Type__c 
             FROM ACME_Scoring_Criteria__mdt 
             WHERE Active__c = true 
             WITH SECURITY_ENFORCED];

        // Process each scoring criterion
        for (ACME_Scoring_Criteria__mdt criterion : scoringCriteria) {
            Decimal criterionScore = evaluateCriterion(lead, criterion);
            totalScore += criterionScore * (criterion.Weight__c / 100);
        }

        // Ensure score is within 0-100 range
        return Math.min(Math.max(totalScore, 0), 100);
    }

    /**
     * @description Evaluate individual scoring criterion
     * @param lead Lead record to evaluate
     * @param criterion Scoring criterion metadata
     * @return Decimal Score for the specific criterion
     */
    private static Decimal evaluateCriterion(Lead lead, ACME_Scoring_Criteria__mdt criterion) {
        switch on criterion.Criteria_Type__c {
            when 'EMAIL' {
                return lead.Email != null ? 100 : 0;
            }
            when 'INDUSTRY' {
                return evaluateIndustryScore(lead.Industry);
            }
            when 'COMPANY_SIZE' {
                return evaluateCompanySizeScore(lead.NumberOfEmployees);
            }
            when 'LEAD_SOURCE' {
                return evaluateLeadSourceScore(lead.LeadSource);
            }
            when else {
                return 0;
            }
        }
    }

    /**
     * @description Evaluate score based on industry
     * @param industry Lead's industry
     * @return Decimal Industry-based score
     */
    private static Decimal evaluateIndustryScore(String industry) {
        if (String.isBlank(industry)) {
            return 0;
        }

        Map<String, Decimal> industryScores = new Map<String, Decimal>{
            'Technology' => 100,
            'Finance' => 90,
            'Healthcare' => 80,
            'Retail' => 70
        };

        return industryScores.containsKey(industry) ? 
            industryScores.get(industry) : 50;
    }

    /**
     * @description Evaluate score based on company size
     * @param employeeCount Number of employees
     * @return Decimal Company size-based score
     */
    private static Decimal evaluateCompanySizeScore(Integer employeeCount) {
        if (employeeCount == null) {
            return 0;
        }

        if (employeeCount >= 1000) {
            return 100;
        } else if (employeeCount >= 500) {
            return 80;
        } else if (employeeCount >= 100) {
            return 60;
        } else if (employeeCount >= 50) {
            return 40;
        }
        
        return 20;
    }

    /**
     * @description Evaluate score based on lead source
     * @param leadSource Lead's source
     * @return Decimal Lead source-based score
     */
    private static Decimal evaluateLeadSourceScore(String leadSource) {
        if (String.isBlank(leadSource)) {
            return 0;
        }

        Map<String, Decimal> sourceScores = new Map<String, Decimal>{
            'Web' => 100,
            'Referral' => 90,
            'Conference' => 80,
            'Cold Call' => 50
        };

        return sourceScores.containsKey(leadSource) ? 
            sourceScores.get(leadSource) : 30;
    }

    /**
     * @description Update lead score and last scored date
     * @param leadId ID of the lead to update
     * @param score Calculated lead score
     */
    public static void updateLeadScore(Id leadId, Decimal score) {
        // Ensure CRUD and FLS permissions
        if (!Schema.SObjectType.Lead.isUpdateable()) {
            throw new System.NoAccessException('Insufficient permissions to update lead');
        }

        Lead leadToUpdate = new Lead(
            Id = leadId,
            ACME_Lead_Score__c = score,
            ACME_Last_Scored_Date__c = System.now()
        );

        try {
            update leadToUpdate;
        } catch (Exception e) {
            // Log error
            System.debug(LoggingLevel.ERROR, 
                'Error updating lead score: ' + e.getMessage());
            throw e;
        }
    }
}