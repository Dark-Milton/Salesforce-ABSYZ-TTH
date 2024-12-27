public with sharing class AccountTriggerHandler {
    public static void updateRatingField(List<Account> newAccountRecords) {
        for(Account acc: newAccountRecords) {
            if(acc.Industry == 'Agriculture') acc.Rating = 'Hot';
            else if(acc.Industry == 'Consulting') acc.Rating = 'Warm';
            else if(acc.Industry == 'Electronics') acc.Rating = 'Cold';
            else acc.Rating = null;
        }
    }
    public static void onBeforeDelete(List<Account> accountRecords) {
        for(Account acc: accountRecords) {
            List<AggregateResult> contactRecordsCount = [Select Count(Id) contactCount from Contact Where AccountId=:acc.Id];
            if((Decimal)(contactRecordsCount[0].get('contactCount')) > 3) acc.addError('Account cannot be deleted because it has moe than 3 contacts associated');
        }
    }
    public static void updateChildAccounts(Set<Id> parentAccountIds) {
        List<Account> childAccounts = [SELECT Id, ParentId, Phone FROM Account WHERE ParentId IN :parentAccountIds];

        List<Account> accountsToUpdate = new List<Account>();

        for (Account child : childAccounts) {
            String parentPhone = [SELECT Phone FROM Account WHERE Id = :child.ParentId].Phone;

            if (child.Phone != parentPhone) {
                child.Phone = parentPhone;
                accountsToUpdate.add(child);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            Database.update(accountsToUpdate);

            // Set<Id> nextLevelParentIds = new Set<Id>();
            // for (Account acc : accountsToUpdate) {
            //     nextLevelParentIds.add(acc.Id);
            // }

            // if (!nextLevelParentIds.isEmpty()) {
            //     updateChildAccounts(nextLevelParentIds);
            // }
        }
    }

    public static void insertAccDocuments(List<Account> newAccountRecords) {
        List<Account_Document__c> documentsToInsert = new List<Account_Document__c>();

        for (Account acc : newAccountRecords) {
            System.debug('Account Name: ' + acc.Name + ' Account Documents Picklist: ' + acc.Documents__c);
            List<String> picklistValues = acc.Documents__c.split(';');
            for (String picklistValue : picklistValues) {
                Account_Document__c doc = new Account_Document__c();
                doc.Name = acc.Name + ' - ' + picklistValue;
                doc.Account__c = acc.Id;
                documentsToInsert.add(doc);
            }
        }

        if (!documentsToInsert.isEmpty()) {
            Database.insert(documentsToInsert);
        }
    }
}