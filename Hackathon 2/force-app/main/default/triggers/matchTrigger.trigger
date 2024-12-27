trigger matchTrigger on Match__c (before update, after update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        System.debug('Before Update');
        MatchHandler.getManOfTheMatch(Trigger.new, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        MatchHandler.updateVenueDescription(Trigger.new, Trigger.oldMap);
    }
}