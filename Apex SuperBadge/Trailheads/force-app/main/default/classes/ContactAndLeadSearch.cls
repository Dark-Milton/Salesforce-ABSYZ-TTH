public with sharing class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String name) {
        return [FIND :name IN ALL FIELDS RETURNING Contact(FirstName,LastName), Lead(FirstName,LastName)];
    }
}