@isTest
public with sharing class contactValueUpdate_Test {
    @isTest
    public static void onUpdateContactValue_test() {
        //On Insert of Contact with empty account
        Contact con = new Contact(
            FirstName= 'Test',
            LastName= 'Contact',
            Value__c = 100
        );
        insert con;

        //On Insert of Contact Test on new Account
        Account acc1 = new Account(
            Name = 'Test Account'
        );
        insert acc1;

        Contact con1 = new Contact(
            FirstName= 'Test',
            LastName= 'Contact 1',
            AccountId = acc1.Id,
            Value__c = 100
        );
        insert con1;

        Account actualAcc1 = [Select Id, Total_Value__c from Account Where Id =:acc1.Id Limit 1];
        System.debug(con1);
        System.debug(acc1);
        System.debug(actualAcc1);
        System.assertEquals(100, actualAcc1.Total_Value__c);

        //On Update of Contact Test
        con1.Value__c = 200;
        update con1;

        Account actualAcc2 = [Select Id, Total_Value__c from Account Where Id =:acc1.Id Limit 1];
        System.assertEquals(200, actualAcc2.Total_Value__c);

        //On reparenting account 
        Account acc2 = new Account(
            Name = 'Test Account 2'
        );
        insert acc2;
        con1.AccountId = acc2.Id;
        update con1;

        Account actualAcc3 = [Select Id, Total_Value__c from Account Where Id =:acc1.Id Limit 1];
        System.assertEquals(0, actualAcc3.Total_Value__c);
        Account actualAcc4 = [Select Id, Total_Value__c from Account Where Id =:acc2.Id Limit 1];
        System.assertEquals(200, actualAcc4.Total_Value__c);

        //delete contact
        delete con1;
        Account actualAcc5 = [Select Id, Total_Value__c from Account Where Id =:acc2.Id Limit 1];
        System.assertEquals(0, actualAcc5.Total_Value__c);
        
        //undelete contact
        undelete con1;
        Account actualAcc6 = [Select Id, Total_Value__c from Account Where Id =:acc2.Id Limit 1];
        System.assertEquals(200, actualAcc6.Total_Value__c);
    }
}