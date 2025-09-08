public with sharing class StoryController {
    @AuraEnabled(cacheable=true)
    public static List<Story__c> getStories() {
        return [
            SELECT Id, Name, Status__c 
            FROM Story__c 
            ORDER BY CreatedDate DESC
        ];
    }
}