public with sharing class sendDiscProgramReportQueueable implements Queueable {
    
    // A list to hold the Account records to process
    public String report;

    // Constructor to pass report to mail
    public sendDiscProgramReportQueueable(String report) {
        this.report = report;
    }
    
    // The execute method to process the chunk of records
    public void execute(QueueableContext context) {
        // Send email to marketing team
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Expired Discount Programs archived');
        mail.setToAddresses(new String[] { 'secondarysumanth@gmail.com' });
        mail.setPlainTextBody('All expired discount programs are archived: \n' + this.report);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    // Static method to start the process
    public static void startQueueableJob(String report) {
        // Enqueue the first queueable job
        System.enqueueJob(new sendDiscProgramReportQueueable(report));
    }
}