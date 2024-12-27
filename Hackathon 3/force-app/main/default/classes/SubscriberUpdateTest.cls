@isTest
public with sharing class SubscriberUpdateTest {
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

       
       List<Subscriber__c> subList = new List<Subscriber__c>();
       Subscriber__c sub1 = new Subscriber__c(
        Name='sub1',
        Discount_Program__c=discPrgRec1.Id,
        Status__c='Active'
       );
       subList.add(sub1);
       Subscriber__c sub2 = new Subscriber__c(
        Name='sub2',
        Discount_Program__c=discPrgRec2.Id,
        Status__c='Active'
       );
       subList.add(sub2);
       Database.insert(subList);
       

      // Schedule the test job
      String jobID = scheduleSubscriberUpdateBatch.scheduleJob();

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
        FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals('0 0 0 1/1 * ?', ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2024-11-06 00:00:00', String.valueOf(ct.NextFireTime));
       
      System.assertNotEquals('Expired', [SELECT id, Name, Status__c FROM Subscriber__c WHERE id = :sub1.id].Status__c);
      System.assertNotEquals('Expired', [SELECT id, Name, Status__c FROM Subscriber__c WHERE id = :sub2.id].Status__c);

   Test.stopTest();

   }
}