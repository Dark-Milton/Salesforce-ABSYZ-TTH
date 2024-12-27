@isTest
public with sharing class AccountProcessorTest {
    @isTest
    public static void testCountContacts() {
        Account a = new Account(Name = 'Test Account');
        Database.insert(a);
        Account a1 = new Account(Name = 'Test Account 1');
        Database.insert(a1);

        List<Contact> contacts = RandomContactFactory.generateContactsOfAccount(5, a.Id);
        Database.insert(contacts);

        Test.startTest();
            AccountProcessor.countContacts(new List<Id>{a.Id, a1.Id});
        Test.stopTest();

        a = [SELECT Number_Of_Contacts__c FROM Account WHERE Id =: a.Id];
        System.assertEquals(5, a.Number_Of_Contacts__c);
        a1 = [SELECT Number_Of_Contacts__c FROM Account WHERE Id =: a1.Id];
        System.assertEquals(0, 1.Number_Of_Contacts__c);
    }
}