trigger timeCardTrigger on Timecard__c (before insert, before update, after insert, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            TimecardTriggerHandler.handleTimecardTrigger(Trigger.new, null);
        }
        if(Trigger.isUpdate){
            TimecardTriggerHandler.handleTimecardTrigger(Trigger.new, Trigger.oldMap);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert){
            TimecardTriggerHandler.handleTimecardSplit(Trigger.newMap, null);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isUpdate){
            TimecardTriggerHandler.handleTimecardSplitUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}