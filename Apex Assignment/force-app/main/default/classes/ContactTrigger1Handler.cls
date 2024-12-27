public with sharing class ContactTrigger1Handler {
    public static void updateAccountValue(Map<Id, Contact> newContactRecordsMap, Map<Id, Contact> oldContactRecordsMap) {
        System.debug('After Change of Account');
        Set<Id> accIds = new Set<Id>();
        for(Contact con: newContactRecordsMap.values()) {
            if(oldContactRecordsMap == null) {
                if(con.AccountId != null)
                    accIds.add(con.AccountId);
            }
            else {
                if(con.AccountId != null) accIds.add(con.AccountId);
                if(oldContactRecordsMap.get(con.Id).AccountId != null) accIds.add(oldContactRecordsMap.get(con.Id).AccountId);
            }
        }
        System.debug(accIds);
        if(accIds.isEmpty()) return;
        List<Account> accToBeUpdated = new List<Account>();
        List<Account> accWithoutContactList = [SELECT Id, Total_Value__c FROM Account WHERE Id in:accIds and Id not in (select AccountId from Contact where AccountId in :accIds)];
        for(Account accWithoutContact: accWithoutContactList) {
            Account acc = new Account(
                Id=accWithoutContact.Id,
                Total_Value__c = 0
            );
            accToBeUpdated.add(acc);
        }
        System.debug(accToBeUpdated);
        List<AggregateResult> conList = [Select AccountId ,sum(Value__c) totalValue from Contact where AccountId in :accIds group by AccountId];
        for(AggregateResult con: conList) {
            Account acc = new Account(
                Id=(Id)con.get('AccountId'),
                Total_Value__c = (Decimal)con.get('totalValue')
            );
            accToBeUpdated.add(acc);
        }
        System.debug(accToBeUpdated);

        Database.update(accToBeUpdated);
    }
}