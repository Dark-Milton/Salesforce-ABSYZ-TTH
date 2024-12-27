public with sharing class AccountTriggerHandler {
    public static void updateAccountAddress(List<Account> newAccounts) {
        for(Account acc : newAccounts) {
            if(acc.Match_Billing_Address__c) {
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
}