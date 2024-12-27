public with sharing class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIds) {
        List<AggregateResult> results = [SELECT AccountId, COUNT(Id) contactCount FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId];
        Map<Id, Integer> accountContactCounts = new Map<Id, Integer>();
        for(AggregateResult agg: results) {
            accountContactCounts.put((Id) agg.get('AccountId'), (Integer) agg.get('contactCount'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for(Id accountId: accountIds) {
            Account acc = new Account(Id = accountId);
            if(accountContactCounts.containsKey(accountId)) acc.Number_Of_Contacts__c = accountContactCounts.get(accountId);
            else acc.Number_Of_Contacts__c = 0;
            accountsToUpdate.add(acc);
        }

        Database.update(accountsToUpdate);
    }
}