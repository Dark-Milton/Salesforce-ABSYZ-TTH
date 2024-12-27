trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            OpportunityTriggerHandler.createTaskonClosedWon(Trigger.new);
        }
    }
}