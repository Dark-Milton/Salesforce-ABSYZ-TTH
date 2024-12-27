trigger leadTrigger on Lead (After insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        // leadTriggerHandler.onLeadInsert(trigger.new);
        leadTriggerHandler.onInsertConvertLead(trigger.new);
    }
}