trigger contactTrigger on Contact (before insert, before update, after insert, after update, after delete, after undelete) {
    static Boolean isExecuted = true;

    if(Trigger.isBefore && Trigger.isInsert) {
        ContactTriggerHandler.onBeforeInsert(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        ContactTriggerHandler.onBeforeUpdate(trigger.oldMap, trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert) {
        // ContactTriggerHandler.onAfterUpdate(trigger.new);
        ContactTriggerHandler.updatePrimaryContactList(trigger.new, null);
        ContactTriggerHandler.onInsertUpdateDeleteActiveContact(trigger.new);
        ContactTriggerHandler.onAfterInsert(trigger.new);
        ContactTrigger1Handler.updateAccountValue(Trigger.newMap, null);
    }
    if(Trigger.isAfter && Trigger.isUpdate) {
        ContactTriggerHandler.updatePrimaryContactList(trigger.new, trigger.oldMap);
        ContactTriggerHandler.onInsertUpdateDeleteActiveContact(trigger.new);
        ContactTrigger1Handler.updateAccountValue(Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isDelete) {
        ContactTriggerHandler.onInsertUpdateDeleteActiveContact(trigger.old);
        ContactTrigger1Handler.updateAccountValue(Trigger.oldMap, null);
    }
    if(Trigger.isAfter && Trigger.isUndelete) {
        ContactTrigger1Handler.updateAccountValue(Trigger.newMap, null);
    }
}