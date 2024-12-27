public with sharing class UpdateContactsDescriptionBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for the records you want to process
        return Database.getQueryLocator('SELECT Id, Description, Account.Name, Account.Description FROM Contact Where AccountId != null'); 
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        
        for (SObject record : scope) {
            Contact con = (Contact) record;
            con.Description = con.Account.Name;
            if(con.Account.Description != null){
                con.Description += ' : ' + con.Account.Description;
            }
        }
        System.debug(scope);
        Database.update(scope);
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('Processed');
    }
}