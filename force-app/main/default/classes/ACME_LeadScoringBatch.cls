public with sharing class ACME_LeadScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
    private List<Lead> leadsToProcess;
    private Integer totalLeadsProcessed = 0;
    private Integer leadsScored = 0;

    public ACME_LeadScoringBatch() {
        leadsToProcess = [SELECT Id, Email, Company, LeadSource, Status, Rating, 
                          NumberOfEmployees, AnnualRevenue 
                          FROM Lead 
                          WHERE Status != 'Converted' 
                          AND Status != 'Closed'];
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Email, Company, LeadSource, Status, Rating, 
                                         NumberOfEmployees, AnnualRevenue 
                                         FROM Lead 
                                         WHERE Status != 'Converted' 
                                         AND Status != 'Closed']);
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead lead : scope) {
            Integer score = calculateLeadScore(lead);
            lead.ACME_Lead_Score__c = score;
            
            if (score >= 80) {
                lead.Rating = 'Hot';
            } else if (score >= 50) {
                lead.Rating = 'Warm';
            } else {
                lead.Rating = 'Cold';
            }

            leadsToUpdate.add(lead);
            leadsScored++;
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }

        totalLeadsProcessed += scope.size();
    }

    private Integer calculateLeadScore(Lead lead) {
        Integer score = 0;

        // Company Size Score
        if (lead.NumberOfEmployees != null) {
            if (lead.NumberOfEmployees >= 500) {
                score += 30;
            } else if (lead.NumberOfEmployees >= 100) {
                score += 20;
            } else if (lead.NumberOfEmployees >= 50) {
                score += 10;
            }
        }

        // Annual Revenue Score
        if (lead.AnnualRevenue != null) {
            if (lead.AnnualRevenue >= 50000000) {
                score += 30;
            } else if (lead.AnnualRevenue >= 10000000) {
                score += 20;
            } else if (lead.AnnualRevenue >= 1000000) {
                score += 10;
            }
        }

        // Lead Source Score
        if (lead.LeadSource != null) {
            switch on lead.LeadSource {
                when 'Web', 'Referral' {
                    score += 20;
                }
                when 'Trade Show', 'Partner' {
                    score += 10;
                }
            }
        }

        return score;
    }

    public void finish(Database.BatchableContext BC) {
        // Optional: Send a completion notification or log results
        System.debug('Total Leads Processed: ' + totalLeadsProcessed);
        System.debug('Total Leads Scored: ' + leadsScored);
    }
}