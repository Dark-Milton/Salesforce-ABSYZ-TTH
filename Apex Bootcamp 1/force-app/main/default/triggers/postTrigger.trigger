trigger postTrigger on Post__c (before update, after update) {
    // if(trigger.isUpdate && trigger.isBefore) {
    //     postTriggerHandler.onBeforeUpdate(trigger.new);
    // }
    if(trigger.isUpdate && trigger.isAfter) {
        postTriggerHandler.onAfterUpdate(trigger.new);
    }
}