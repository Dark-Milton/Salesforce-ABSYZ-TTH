trigger accountTrigger on Account (before insert, after insert, before update, before delete, after update) {
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        AccountTriggerHandler.updateRatingField(trigger.new);
    }
    if(trigger.isBefore && trigger.isDelete) {
        AccountTriggerHandler.onBeforeDelete(trigger.old);
    }
    if(trigger.isAfter && trigger.isUpdate) {
        Set<Id> parentAccountIds = new Set<Id>();

        for (Account acc : Trigger.new) {
            if (acc.Phone != Trigger.oldMap.get(acc.Id).Phone) {
                parentAccountIds.add(acc.Id);
            }
        }

        if (parentAccountIds.isEmpty()) {
            return;
        }

        AccountTriggerHandler.updateChildAccounts(parentAccountIds);
    }
    if(trigger.isAfter && trigger.isInsert) {
        AccountTriggerHandler.insertAccDocuments(trigger.new);
    }
}