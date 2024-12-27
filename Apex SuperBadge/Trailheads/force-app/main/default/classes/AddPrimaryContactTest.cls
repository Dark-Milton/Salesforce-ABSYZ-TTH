@IsTest
public with sharing class AddPrimaryContactTest {
    @IsTest
    public static void testAddPrimaryContact() {
        List<Account> accountsList = new List<Account>();
        for (Integer i=0; i<50;i++) {
            Account a = new Account(Name=String.valueOf(i),BillingState='NY');
            accountsList.add(a);
        }
        for (Integer i=0; i<50;i++) {
            Account a = new Account(Name=String.valueOf(50+i),BillingState='CA');
            accountsList.add(a);
        }      
        Database.insert(accountsList);


        Test.startTest();
            Contact c = new Contact(LastName='Alex');

            System.enqueueJob(new AddPrimaryContact(c,'CA'));
        Test.stopTest();

        List<Contact> conList = new List<Contact>([select Id from Contact]);
        System.assertEquals(50, conList.size());
    }

}