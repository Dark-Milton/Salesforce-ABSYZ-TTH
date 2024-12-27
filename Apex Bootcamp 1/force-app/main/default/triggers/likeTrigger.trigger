trigger likeTrigger on Like__c (before insert, after insert) {
    // if(trigger.isBefore && trigger.isInsert) {
    //     Map<Id, Decimal> postIdWithLikesMap = new Map<Id, Decimal>();
    //     for(Like__C likeInstance: trigger.new) {
    //         if(postIdWithLikesMap.containsKey(likeInstance.Post__c)){
    //             postIdWithLikesMap.put(likeInstance.Post__c, postIdWIthLikesMap.get(likeInstance.Post__c)+1);
    //         }
    //         else {
    //             postIdWithLikesMap.put(likeInstance.Post__c, 1);
    //         }
    //     }
        
    //   //     List<Post__c> postList = [Select Id, Likes__c, (Select Id from Likes__r) from Post__c where Id IN: postIdWithLikesMap.keySet()];
    //     List<Post__c> postList = [Select Id, Likes__c from Post__c where Id IN: postIdWithLikesMap.keySet()];
    //     for(Post__c post_instance : postList)  {
    //         // post_instance.likes__c =  post_instance.Likes__r.size() + postIdWithLikesMap.get(post_instance.Id);
    //         post_instance.likes__c =  post_instance.likes__c + postIdWithLikesMap.get(post_instance.Id);
    //     }

    //     Database.update(postList);

    // }
    if(trigger.isAfter && trigger.isInsert) {
        
        Set<Id> postId = new Set<Id>();
        for(Like__c likeInstance: trigger.new) {
            postId.add(likeInstance.Post__c);
        }

        // List<Post__c> postList = [Select Id, Likes__c, (Select Id from Likes__r) from Post__c where Id IN: postId];
        List<Post__c> postList = [Select Id, Likes__c, (Select Id from Likes__r Where Id In: trigger.new) from Post__c where Id IN: postId];
        for(Post__c post_instance : postList)  {
            System.debug(post_instance);
            post_instance.likes__c = post_instance + post_instance.Likes__r.size();
            // post_instance.likes__c =  post_instance.Likes__r.size();
        }

        Database.update(postList);

    }
}