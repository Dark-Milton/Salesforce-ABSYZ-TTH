public with sharing class LineItemTriggerHandler {
    public static void onInsertLineItemUpdateMerchandiseCount(List<Line_Item__c> newLineItemRecords) {
        Set<Id> merchIds = new Set<Id>();

        for(Line_Item__c lineItem: newLineItemRecords) {
            merchIds.add(lineItem.Merchandise__c);
        }

        List<Merchandise__c> merchList = [Select Id, Name, 	No_of_Line_Items__c, (Select Id, Name from Line_Items__r Where Id In:newLineItemRecords) from Merchandise__c Where Id In:merchIds];

        for(Merchandise__c merch: merchList) {
            merch.No_of_Line_Items__c += merch.Line_Items__r.size();
        }
        Database.update(merchList);
    }
    public static void onDeleteLineItemUpdateMerchandiseCount(List<Line_Item__c> lineItemRecords) {
        Set<Id> merchIds = new Set<Id>();

        for(Line_Item__c lineItem: lineItemRecords) {
            merchIds.add(lineItem.Merchandise__c);
        }
        List<Merchandise__c> merchList = [Select Id, Name, 	No_of_Line_Items__c from Merchandise__c Where Id In:merchIds];
        Map<Id, Merchandise__c> merchMap = new Map<Id,Merchandise__c>();
        for(Merchandise__c merch: merchList)
            merchMap.put(merch.Id, merch);


        for(Line_Item__c lineItem: lineItemRecords) {
            Merchandise__c merch = merchMap.get(lineItem.Merchandise__c);
            merch.No_of_Line_Items__c -=1;
            merchMap.put(merch.Id, merch);
        }
        Database.update(merchMap.values());
    }
}