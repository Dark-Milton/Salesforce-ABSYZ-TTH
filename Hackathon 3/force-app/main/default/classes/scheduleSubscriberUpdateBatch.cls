public with sharing class scheduleSubscriberUpdateBatch implements Schedulable {
    
    // The execute method that is called when the job runs
    public void execute(SchedulableContext sc) {
        // Call Batch class
        Id batchJobId = Database.executeBatch(new DiscountProgramSubscriberUpdateBatch(), 200);
    }
    
    // Method to schedule the job
    public static String scheduleJob() {
        String cronExpression = '0 0 0 1/1 * ? ';  // Run monthly once
        String jobID = System.schedule('Update Subscriber Status on Program Expire', cronExpression, new scheduleSubscriberUpdateBatch());
        return jobID;
    }
}