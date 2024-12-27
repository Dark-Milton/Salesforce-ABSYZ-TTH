public with sharing class ScheduleArchiveDiscountProgram implements Schedulable {
    
    // The execute method that is called when the job runs
    public void execute(SchedulableContext sc) {
        // Call Batch class
        Id batchJobId = Database.executeBatch(new ArchiveDiscountProgram(), 200);
    }
    
    // Method to schedule the job
    public static String scheduleJob() {
        String cronExpression = '0 0 0 1 1/1 ? *';  // Run monthly once
        String jobID = System.schedule('Archive Discount Program Scheduled Batch', cronExpression, new ScheduleArchiveDiscountProgram());
        return jobID;
    }
}