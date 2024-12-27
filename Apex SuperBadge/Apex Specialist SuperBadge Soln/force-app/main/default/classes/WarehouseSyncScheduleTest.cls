@isTest
public with sharing class WarehouseSyncScheduleTest {
    @isTest
    public static void testWarehouseSyncSchedule() {
        Test.startTest();
            String jobId = System.schedule('WarehouseSyncScheduleJob', '0 0 1 1/1 * ? *', new WarehouseSyncSchedule());
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM CronTrigger WHERE Id = :jobId]);
    }
}