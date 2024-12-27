trigger driverTrigger on Driver__c (before delete) {
    if(Trigger.isBefore && Trigger.isDelete) {
        for(Driver__c driverRecord: trigger.old) {
            if(driverRecord.Related_Contact__c != null) {
                driverRecord.addError('Cannot delete Driver record until it is linked to contact');
            }
        }
    }
}