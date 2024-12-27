public with sharing class DiscountProgramSubscriberUpdateBatch implements Database.Batchable<SObject> {

    // The start method where the query for records is defined
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for the discount program records past end date
        return Database.getQueryLocator('SELECT Id, Name, Discount_Percentage__c, Applicable_Vehicle_Types__c, Start_Date__c, End_Date__c FROM Discount_Program__c Where End_Date__c < TODAY');
    }

    // The execute method where records are processed in batches
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        
        Set<Id> discProgramIds = new Set<Id>();
        // Business logic to process the records
        for (SObject record : scope) {
            Discount_Program__c discProgram = (Discount_Program__c) record;
            discProgramIds.add(discProgram.Id);
        }

        List<Subscriber__c> subscribeRecords = [Select Id, Status__c, Discount_Program__c from Subscriber__c where Discount_Program__c in: discProgramIds and Status__c = 'Active'];
        for(Subscriber__c sub: subscribeRecords) {
            sub.Status__c = 'Expired';
        }
        Database.update(subscribeRecords);
    }

    // The finish method where you can log the total number of records processed
    public void finish(Database.BatchableContext bc) {
        
    }
}