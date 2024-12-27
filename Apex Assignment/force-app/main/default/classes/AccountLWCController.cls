public with sharing class AccountLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts() {
        return [Select Id, Name from Account];
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getContactsBasedOnType(String type) {
        return [Select Id, Name, (Select Id, FirstName, LastName, Email, Phone from Contacts) from Account Where Ownership=:type];
    }
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsWithLimit(Integer limitNo) {
        return [Select Id, Name from Account Limit :limitNo];
    }
}