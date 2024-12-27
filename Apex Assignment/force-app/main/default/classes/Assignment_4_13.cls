public with sharing class Assignment_4_13 {
    public static void insertInvoiceList(String invoiceName) {
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        for(Integer i=0;i<10;i++) {
            Invoice__c invoiceInstance = new Invoice__c(Name__c=invoiceName, Status__c='Open');
            invoiceList.add(invoiceInstance);
        }
        Database.SaveResult[] srList = Database.insert(invoiceList, true);
        List<Id> invoiceIds = new List<Id>();
        for(Database.SaveResult sr: srList) invoiceIds.add(sr.getId());
        updateInvoiceList(invoiceIds);
    }
    public static void updateInvoiceList(List<Id> invoiceIds) {
        List<Invoice__c> invoiceList = [Select Id, Name from Invoice__c WHere Id in:invoiceIds];
        System.debug('Before Update: ' + invoiceList);
        for(Invoice__c inv: invoiceList) {
            inv.value__c = 100;
        }
        Database.update(invoiceList);
    }
}