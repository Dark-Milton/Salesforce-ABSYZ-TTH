trigger invoiceTrigger on Invoice__c (before insert, before delete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        InvoiceTriggerHandler.appendAbsyztoName(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isDelete) {
        InvoiceTriggerHandler.preventDeleteOfClosedInvoice(trigger.old);
    }
}