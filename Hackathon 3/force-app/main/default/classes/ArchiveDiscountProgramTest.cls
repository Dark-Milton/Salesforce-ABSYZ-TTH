@isTest
public with sharing class ArchiveDiscountProgramTest {
   static testmethod void test() {
   Test.startTest();
       List<Discount_Program__c> discPrgList = new List<Discount_Program__c>();
       Discount_Program__c discPrgRec1 = new Discount_Program__c(
           Name='discPrgRec1',
           Start_Date__c = Date.today() - 10,
           End_Date__c = Date.today() - 4,
           Discount_Percentage__c = 60
       );
       discPrgList.add(discPrgRec1);
       Discount_Program__c discPrgRec2 = new Discount_Program__c(
           Name='discPrgRec2',
           Start_Date__c = Date.today() - 10,
           End_Date__c = Date.today() - 4,
           Discount_Percentage__c = 40
       );
       discPrgList.add(discPrgRec2);
       Database.insert(discPrgList);
       

      // Schedule the test job
      String jobID = ScheduleArchiveDiscountProgram.scheduleJob();

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals('0 0 0 1 1/1 ? *', ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2024-12-01 00:00:00', String.valueOf(ct.NextFireTime));
       
      System.assertNotEquals(null, [SELECT id, name FROM account WHERE id = :discPrgRec2.id]);

   Test.stopTest();

   }
}