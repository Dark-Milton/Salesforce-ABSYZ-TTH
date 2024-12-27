public with sharing class ContactLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAccountRelatedContacts(Id accountId) {
        return [Select Id, Name, Title, Phone, Email, Owner.Name From Contact Where AccountId=:accountId];
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactDetails() {
        return [Select Id, Name, Title, Phone, Email From Contact];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContactsByName(String name) {
        String searchTerm = '%'+name+'%';
        return [Select Id, Name, Phone, Email From Contact Where Name Like :searchTerm];
    }
}