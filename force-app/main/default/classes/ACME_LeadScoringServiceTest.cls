/**
 * @description Test class for Lead Scoring Service
 * @author Studio Science
 * @date 2024-02-15
 */
@isTest
private class ACME_LeadScoringServiceTest {
    
    @isTest
    static void testCalculateLeadScore_NullLead() {
        Integer score = ACME_LeadScoringService.calculateLeadScore(null);
        System.assertEquals(0, score, 'Null lead should return zero score');
    }
    
    @isTest
    static void testCalculateLeadScore_FullyQualifiedLead() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ACME Corp',
            NumberOfEmployees = 1000,
            Industry = 'Technology',
            Title = 'CTO',
            Country = 'United States'
        );
        
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        System.assertNotEquals(0, score, 'Lead score should not be zero');
        System.assert(score <= 100, 'Lead score should not exceed 100');
    }
    
    @isTest
    static void testCalculateLeadScore_MinimalLead() {
        Lead testLead = new Lead(
            FirstName = 'Minimal',
            LastName = 'Lead',
            Company = 'Small Company'
        );
        
        Integer score = ACME_LeadScoringService.calculateLeadScore(testLead);
        
        System.assert(score >= 0, 'Lead score should be non-negative');
        System.assert(score <= 100, 'Lead score should not exceed 100');
    }
    
    @isTest
    static void testLeadScoringMetrics() {
        Map<String, Integer> demoWeights = ACME_LeadScoringMetrics.getDemographicWeights();
        Map<String, Integer> engageWeights = ACME_LeadScoringMetrics.getEngagementWeights();
        
        System.assert(!demoWeights.isEmpty(), 'Demographic weights should not be empty');
        System.assert(!engageWeights.isEmpty(), 'Engagement weights should not be empty');
    }
}