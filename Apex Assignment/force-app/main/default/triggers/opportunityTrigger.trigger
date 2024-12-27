trigger opportunityTrigger on Opportunity (before delete) {
    if(Trigger.isBefore && Trigger.isDelete) {
        OpportunityTriggerHandler.onBeforeDelete(trigger.old);
    }
}