public with sharing class MerchandiseTriggerHandler {
    public static void updateUnitPriceOfLineItems(List<Merchandise__c> newMerchandiseRecords) {
        List<Line_Item__c> lineItemList = new List<Line_Item__c>();
        Set<Id> merchIds = new Set<Id>();

        for(Merchandise__c merch: newMerchandiseRecords) {
            if(merch.Quantity__c == 20) {
                merchIds.add(merch.Id);
            }
        }

        lineItemList = [Select Id, Unit_Price__c from Line_Item__c Where Merchandise__c IN:merchIds];
        for(Line_Item__c lineItem: lineItemList) {
            lineItem.Unit_Price__c *= 2;
        }
        Database.update(lineItemList);
    }
}