public with sharing class AccountHandler {
    public static Account insertNewAccount(String name) {
        try {
            Account newAccount = new Account(Name = name);
            insert newAccount;
            return newAccount;
        } catch (DmlException e) {
            return null;
        }
    }
}