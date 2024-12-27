public class CountProcessedRecordsBatch implements Database.Batchable<SObject> {
    
    // A variable to keep track of the total number of records processed
    public Integer processedRecordsCount = 0;
    
    // The start method where the query for records is defined
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for the records you want to process
        return Database.getQueryLocator('SELECT Id FROM Account');  // Example query for Accounts
    }

    // The execute method where records are processed in batches
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        // Process the records here (scope contains the current batch of records)
        
        // Increment the counter by the number of records processed in this batch
        processedRecordsCount += scope.size();
        System.debug('processedRecordsCount: ' + processedRecordsCount);
        // Business logic to process the records
        for (SObject record : scope) {
            Account acc = (Account) record;
            // Example processing: updating account names
            acc.Name = acc.Name + ' - Processed';
        }
        // Update the records after processing
        update scope;
    }

    // The finish method where you can log the total number of records processed
    public void finish(Database.BatchableContext bc) {
        // Log the total number of processed records
        System.debug('Total number of records processed: ' + processedRecordsCount);

        // You can also notify users or send emails with the result
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Batch Process Completed');
        mail.setToAddresses(new String[] { 'secondarysumanth@gmail.com' });
        mail.setPlainTextBody('The batch job has completed. Total records processed: ' + processedRecordsCount);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}