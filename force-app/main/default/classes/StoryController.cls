public with sharing class StoryController {
    @AuraEnabled(cacheable=true)
    public static List<Story__c> getStories() {
        return [SELECT Id, Name, Description__c, Status__c 
                FROM Story__c 
                LIMIT 1000];
    }

    @AuraEnabled
    public static Story__c createStory(Story__c story) {
        try {
            insert story;
            return story;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateStoryStatus(Id storyId, String status) {
        try {
            Story__c story = [SELECT Id, Status__c FROM Story__c WHERE Id = :storyId LIMIT 1];
            story.Status__c = status;
            update story;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}