trigger lineItemTrigger on Line_Item__c (after insert, after delete) {
    if(Trigger.isAfter && Trigger.isInsert) {
        LineItemTriggerHandler.onInsertLineItemUpdateMerchandiseCount(trigger.new);
    }
    if(Trigger.isAfter && Trigger.isDelete) {
        LineItemTriggerHandler.onDeleteLineItemUpdateMerchandiseCount(trigger.old);
    }
}