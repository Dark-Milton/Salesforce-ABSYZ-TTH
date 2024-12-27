public with sharing class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer count, String lastName) {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'Test ' + i,
                LastName = lastName
            ));
        }
        return contacts;
    }
    public static List<Contact> generateContactsOfAccount(Integer count, Id accId) {
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'Test ' + i,
                LastName = 'User',
                AccountId = accId
            ));
        }
        return contacts;
    }
}