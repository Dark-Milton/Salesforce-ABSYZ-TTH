public with sharing class ArchiveDiscountProgram implements Database.Batchable<SObject>, Database.Stateful {
    //statefull variable for report
    String report = '';
    // The start method where the query for records is defined
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for the discount program records past end date
        return Database.getQueryLocator('SELECT Id, Name, Discount_Percentage__c, Applicable_Vehicle_Types__c, Start_Date__c, End_Date__c FROM Discount_Program__c Where End_Date__c < TODAY');
    }

    // The execute method where records are processed in batches
    public void execute(Database.BatchableContext bc, List<SObject> scope) {

        //list variable for creating archive records
        List<Archived_Discount_Program__c> archivedDiscountProgramList = new List<Archived_Discount_Program__c>();
        
        // Business logic to process the records
        for (SObject record : scope) {
            Discount_Program__c discProgram = (Discount_Program__c) record;
            if(discProgram.Discount_Percentage__c > 50) report += discProgram.Name + ' - ' + discProgram.Discount_Percentage__c + '\n';
            Archived_Discount_Program__c archiveRecord = new Archived_Discount_Program__c(
                Name = discProgram.Name,
                Start_Date__c = discProgram.End_Date__c,
                End_Date__c = discProgram.End_Date__c,
                Discount_Percentage__c = discProgram.Discount_Percentage__c,
                Applicable_Vehicle_Types__c = discProgram.Applicable_Vehicle_Types__c
            );
            archivedDiscountProgramList.add(archiveRecord);
        }
        // Insert Archive records
        Database.insert(archivedDiscountProgramList);
        // Delete Discount Program records
        Database.delete(scope);
    }

    // The finish method where you can log the total number of records processed
    public void finish(Database.BatchableContext bc) {
        // Log the report of records
        System.debug('Report: ' + report);

        sendDiscProgramReportQueueable.startQueueableJob(report);
    }
}