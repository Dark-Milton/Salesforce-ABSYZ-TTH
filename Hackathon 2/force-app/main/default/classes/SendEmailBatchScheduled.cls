public class SendEmailBatchScheduled implements Schedulable {
    
    // The execute method that is called when the job runs
    public void execute(SchedulableContext sc) {
        //Call the Send Email BAtch Process
        Database.executeBatch(new SendEmailBatch(), 20);
    }
    
    // Method to schedule the job
    public static void scheduleJob() {
        String cronExpression = '0 0 0 * * ?';  // Run at midnight every day
        System.schedule('Get Win Statistics', cronExpression, new SendEmailBatchScheduled());
    }
}