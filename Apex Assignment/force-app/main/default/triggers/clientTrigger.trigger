trigger clientTrigger on Client__c (before delete) {
    if(Trigger.isBefore && Trigger.isDelete) {
        for(Client__c clientRecord: trigger.old) {
            if(clientRecord.Related_Contact__c != null) {
                clientRecord.addError('Cannot delete Client record until it is linked to contact');
            }
        }
    }
}