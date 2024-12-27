trigger merchandiseTrigger on Merchandise__c (after update) {
    if(Trigger.isAfter && Trigger.isUpdate) {
        MerchandiseTriggerHandler.updateUnitPriceOfLineItems(trigger.new);
    }
}