@isTest
public with sharing class LeadProcessorTest {
    @testSetup 
    static void setup() {
        List<Lead> leads = new List<Lead>();
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(LastName='Lead '+i, Company='Lead', Status='Open - Not Contacted'));
        }
        insert leads;
    }
    @isTest
    public static void testLeadProcessor() {
        Test.startTest();   
            Id batchId = Database.executeBatch(new LeadProcessor(), 200);
        Test.stopTest();

        System.assertEquals(200, [select count() from lead where LeadSource = 'Dreamforce']);
    }
}