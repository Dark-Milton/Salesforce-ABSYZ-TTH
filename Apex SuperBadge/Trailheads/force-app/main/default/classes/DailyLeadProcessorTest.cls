@isTest
public with sharing class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 1/1 * ? *';
    @testSetup
    public static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(LastName = 'Test' + i, Company = 'Test'));
        }
        Database.insert(leads);
    }
    @isTest
    public static void testDailyLeadProcessor() {
        Test.startTest();
            String jobId = System.schedule('DailyLeadProcessor Scheduled', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();

        List<Lead> leads = [SELECT Id, Name, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, leads.size());
    }
}