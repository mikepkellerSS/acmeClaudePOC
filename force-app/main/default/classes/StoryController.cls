public with sharing class StoryController {
    @AuraEnabled(cacheable=true)
    public static List<Story__c> getStories() {
        return [SELECT Id, Name, Description__c, Status__c FROM Story__c];
    }

    @AuraEnabled
    public static Story__c createStory(String name, String description, String status) {
        Story__c newStory = new Story__c(
            Name = name,
            Description__c = description,
            Status__c = status
        );
        insert newStory;
        return newStory;
    }

    @AuraEnabled
    public static void updateStoryStatus(Id storyId, String newStatus) {
        Story__c story = [SELECT Id, Status__c FROM Story__c WHERE Id = :storyId LIMIT 1];
        story.Status__c = newStatus;
        update story;
    }
}