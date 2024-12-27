public with sharing class ContactTriggerHandler {

    public static Boolean isUpdateExecuted = false;
    
    public static void onAfterInsert(List<Contact> contactRecords) {
        List<Client__c> clientRecords = new List<Client__c>();
        List<Driver__c> driverRecords = new List<Driver__c>();
        for(Contact con: contactRecords) {
            if(con.Selected_type__c == 'Client') {
                Client__c client= new Client__c(
                    Name=(con.FirstName + ' ' + con.LastName + ' Client'),
                    Pickup_Location__c = con.MailingStreet + con.MailingCity + ', '+ con.MailingState +' ' + con.MailingPostalCode + con.MailingCountry,
                    Phone_number__c = con.Phone,
                    Related_Contact__c = con.Id                    
                    );
                clientRecords.add(client);
            }
            else if(con.Selected_type__c == 'Driver') {
                Driver__c driver= new Driver__c(
                    Name=con.FirstName + ' ' + con.LastName + ' Driver',
                    Pickup_Location__c = con.MailingStreet + con.MailingCity + ', '+ con.MailingState +' ' + con.MailingPostalCode + con.MailingCountry,
                    Phone_number__c = con.Phone,
                    Related_Contact__c = con.Id                    
                    );
                driverRecords.add(driver);
            }
        }
        if(!clientRecords.isEmpty()) Database.insert(clientRecords);
        if(!driverRecords.isEmpty()) Database.insert(driverRecords);
    }
    public static void onBeforeInsert(List<Contact> contactRecords) {
        for(Contact con: contactRecords) {
            if(con.Vehicle_Number__c == null && con.Selected_type__c != null) {
                con.Vehicle_Number__c.addError('Vehicle Number is required for selected vehicle type');
            }
        }
        Account acc = [Select Id, Name from Account where Name = 'new error event 1' LIMIT 1];
        acc.Name = 'new error event 1';
        Database.update(acc);
        UserUpdateHandler.updateUser('hegdesumanth8@gmail.com');
    }
    public static void onBeforeUpdate(Map<Id, Contact> oldContactRecordsMap, List<Contact> newContactRecords) {
        for(Contact con: newContactRecords) {
            if(con.Vehicle_Number__c == null && con.Selected_type__c != null) {
                con.Vehicle_Number__c.addError('Vehicle Number is required for selected vehicle type');
            }
            if(con.Selected_type__c != oldContactRecordsMap.get(con.Id).Selected_Type__c) {
                con.Selected_type__c.addError('Cannot Change the Selected Type');
            }
        }
    }

    public static void onInsertUpdateDeleteActiveContact(List<Contact> contactRecords) {
        Set<Id> accountIds = new Set<Id>();

        for(Contact con: contactRecords) {
            accountIds.add(con.AccountId);
        }
        
        List<Account> accList = [Select Id, Active_Contact_Count__c, (Select Id from Contacts Where Active__c=true) from Account where Id In:accountIds];

        for(Account acc: accList) {
            acc.Active_Contact_Count__c = acc.Contacts.size();
        }

        Database.update(accList);
    }
    
    public static void updatePrimaryContactList(List<Contact> newContactRecords, Map<Id, Contact> oldContactRecordsMap) {
        List<Contact> oldPrimaryContacts = new List<Contact>();
        // for(Contact oldCon: oldPrimaryContacts) {
        //     oldCon.Primary_Contact__c = false;
        // }
        Set<Id> accIds = new Set<Id>();
        for(Contact con: newContactRecords) {
            if((oldContactRecordsMap == null || oldContactRecordsMap.get(con.Id).Primary_Contact__c != con.Primary_Contact__c) && con.AccountId != null && con.Primary_Contact__c) {
                accIds.add(con.AccountId);
            }
        }
        if(accIds.isEmpty()) return;
        List<Contact> exisitingRecords = [Select Id, LastName, AccountId, Primary_Contact__c from Contact where Id not in:newContactRecords and Primary_Contact__c=true and AccountId!=null];
        Set<Id> oldAccIds = new Set<Id>();
        for(Contact con: exisitingRecords) {
            oldAccIds.add(con.AccountId);
        }
        Map<Id, List<Contact>> accContactMap = new Map<Id, List<Contact>>();

        System.debug('AccIds: ' + accIds);
        System.debug('OldAccIds: ' + oldAccIds);

        Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Primary_Contact_Name__c from Account where Id In:accIds or Id In:oldAccIds]);
        for(Contact con: [Select Id, LastName, AccountId, Primary_Contact__c from Contact where Id in:newContactRecords and Primary_Contact__c=true and AccountId!=null]) {
            if(accContactMap.containsKey(con.AccountId)) {
                con.Primary_Contact__c = false;
                oldPrimaryContacts.add(con);
                List<Contact> contacts = accContactMap.get(con.AccountId);
                contacts.add(con);
                accContactMap.put(con.AccountId, contacts);
            }
            else {
                con.Primary_Contact__c = true;
                oldPrimaryContacts.add(con);
                Account acc = accMap.get(con.AccountId);
                acc.Primary_Contact_Name__c = con.LastName;
                accMap.put(con.AccountId, acc);
                accContactMap.put(con.AccountId, new List<Contact>{con});
            }
        }
        for(Contact con: exisitingRecords) {
            if(accContactMap.containsKey(con.AccountId)) {
                con.Primary_Contact__c = false;
                oldPrimaryContacts.add(con);
                List<Contact> contacts = accContactMap.get(con.AccountId);
                contacts.add(con);
                accContactMap.put(con.AccountId, contacts);
            }
            else {
                con.Primary_Contact__c = true;
                oldPrimaryContacts.add(con);
                Account acc = accMap.get(con.AccountId);
                acc.Primary_Contact_Name__c = con.LastName;
                accMap.put(con.AccountId, acc);
                accContactMap.put(con.AccountId, new List<Contact>{con});
            }
        }
        System.debug('AccMap: ' + accMap);
        System.debug('AccContactMap: ' + accContactMap);
        if(!accMap.values().isEmpty()) Database.update(accMap.values());
        if(!accMap.values().isEmpty()) Database.update(oldPrimaryContacts);
    }
    
}