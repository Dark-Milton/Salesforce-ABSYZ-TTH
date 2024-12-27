public with sharing class WarehouseSyncSchedule implements Schedulable {
    public static String CRON_EXP = '0 0 1 1/1 * ? *';
    public static String JOB_NAME = 'WarehouseSyncScheduleJob';
    // public static void scheduleUpdateInventoryJob() {
    //     System.schedule(JOB_NAME, CRON_EXP, new WarehouseSyncSchedule());
    // }
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new WarehouseCalloutService());
    }
}