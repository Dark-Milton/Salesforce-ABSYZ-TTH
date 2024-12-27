public with sharing class InvoiceTriggerHandler {
    public static void appendAbsyztoName(List<Invoice__c> newInvoiceRecords) {
        for(Invoice__c inv: newInvoiceRecords) {
            if(inv.Invoice_Name__c != null) inv.Invoice_Name__c += ' Absyz';
        }
    }
    public static void preventDeleteOfClosedInvoice(List<Invoice__c> invoiceRecords) {
        for(Invoice__c inv: invoiceRecords) {
            if(inv.Status__c == 'Closed') inv.Status__c.addError('Deleting Closed Invoice Records Not Allowed!');
        }
    }
}