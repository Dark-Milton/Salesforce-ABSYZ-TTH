public with sharing class Assignment_5 {
    public static Map<Merchandise__c, list<Line_Item__c>> mapOfMerchandiseAndLineItems() {
        List<Merchandise__c> merchList = [Select Id, Name, (Select Id, Name from Line_Items__r) from Merchandise__c];
        Map<Merchandise__c, list<Line_Item__c>> merchAndLineItemMap = new Map<Merchandise__c, list<Line_Item__c>>();
        for(Merchandise__c merch: merchList) {
            merchAndLineItemMap.put(merch, merch.Line_Items__r);
        }
        return merchAndLineItemMap;
    }
    public static void updateLineItemsGT100() {
        List<AggregateResult> lineItemList = [Select Sum(Line_Item_Total__c), Invoice__c from Line_Item__c Group By Invoice__c Having Sum(Line_Item_Total__c) > 100];

        Set<String> invoiceIds = new Set<String>();
        for(AggregateResult lineItem: lineItemList) {
             invoiceIds.add(String.ValueOf(lineItem.get('Invoice__c')));
        }

        List<Invoice__c> invoiceList = [Select Id, Status__c from Invoice__c Where Id in:invoiceIds];

        for(Invoice__c inv: invoiceList) {
            inv.Status__c = 'Closed';
        }
        Database.update(invoiceList);
    }
    public static void updateLineItemsBasedOnMerchandise() {
        List<Merchandise__c> merchList = [Select Id, Name, Price__c, (Select Id, Name, Unit_Price__c from Line_Items__r) from Merchandise__c];
        Map<Merchandise__c, list<Line_Item__c>> merchAndLineItemMap = new Map<Merchandise__c, list<Line_Item__c>>();
        for(Merchandise__c merch: merchList) {
            merchAndLineItemMap.put(merch, merch.Line_Items__r);
        }
        List<Line_Item__c> lineItemList = new List<Line_Item__c>();

        for(Merchandise__c merch: merchAndLineItemMap.keySet()) {
            List<Line_Item__c> lineItemListValues = merchAndLineItemMap.get(merch);
            Decimal updatedUnitPrice = merch.Price__c / lineItemListValues.size();

            for(Line_Item__c lineItem: lineItemListValues) {
                lineItem.Unit_Price__c = updatedUnitPrice;
                lineItemList.add(lineItem);
            }
        }

        Database.update(lineItemList);
    }
    public static void updateInvoiceOrderCompleteField() {
        List<Line_Item__c> lineItemsList = [Select Merchandise__r.Order_Complete__c, Invoice__r.Id, Invoice__r.Order_Complete__c from Line_Item__c];
        Set<Id> invoiceIds = new Set<Id>();

        for(Line_Item__c lineItem: lineItemsList) {
            if(lineItem.Merchandise__r.Order_complete__c && !lineItem.Invoice__r.Order_complete__c) {
                invoiceIds.add(lineItem.Invoice__r.Id);
            }
        }

        List<Invoice__c> invoiceList = [Select Id, Order_Complete__c from Invoice__c Where Id in:invoiceIds];

        for(Invoice__c inv: invoiceList)
            inv.Order_Complete__c = true;

        Database.update(invoiceList);
    }
}