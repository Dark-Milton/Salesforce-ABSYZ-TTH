@isTest
public with sharing class TestRestrictContactByName {
    @isTest
    public static void testContactName() {
        Contact c1 = new Contact(
            FirstName = 'Test',
            LastName = 'User'
        );
        // Test.startTest();
            Database.insert(c1);
            System.assertNotEquals(null, [SELECT Id FROM Contact WHERE Id =: c1.Id]);
        // Test.stopTest();


        c1.LastName = 'INVALIDNAME';
        // Test.startTest();
            try{
                Database.update(c1);
            }
            catch(Exception expectedException){
                System.assertEquals(true, expectedException.getMessage().contains('The Last Name "'+c1.LastName+'" is not allowed for DML'));
            }
        // Test.stopTest();

        Contact c2 = new Contact(
            FirstName = 'Test',
            LastName = 'INVALIDNAME'
        );
        // Test.startTest();
            try{
                Database.insert(c2);
            }
            catch(Exception expectedException){
                System.assertEquals(true, expectedException.getMessage().contains('The Last Name "'+c2.LastName+'" is not allowed for DML'));
            }
        // Test.stopTest();


        c2.LastName = 'User 2';
        // Test.startTest();
            Database.insert(c2);
            System.assertNotEquals(null, [SELECT Id FROM Contact WHERE Id =: c2.Id]);
        // Test.stopTest();
    }
}