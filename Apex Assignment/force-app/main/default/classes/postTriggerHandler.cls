public with sharing class postTriggerHandler {
    public static Boolean isNewRecordUpdated = false;
    public static void onBeforeUpdate(List<Post__c> newPostRecords) {
        for(Post__c post : newPostRecords) {
            if(post.Likes__c > 2 && post.Content__c.length() > 20) {
                post.Content__c.addError('Content exceeded 20 characters for more than 2 likes');
            }
            else if(post.Likes__c <= 2 && post.Content__c.length() > 30) {
                post.Content__c.addError('Content exceeded 30 characters for less than 2 likes');
            }
        }
    }
    public static void onAfterUpdate(List<Post__c> newPostRecords) {
        if(isNewRecordUpdated) return;
        List<Post__c> postList = new List<Post__c>();
        for(Post__c post : newPostRecords) {
            if(post.Likes__c == post.Comments__c) {
                // post.Content__c='Likes and Comments are equal';
                Post__c postInstance = new Post__c(Id=post.Id);
                postInstance.Content__c = 'Likes and Comments are equal';
                postList.add(postInstance);
            }
        }
        System.debug(isNewRecordUpdated);
        isNewRecordUpdated = true;
        update postList;
    }
}