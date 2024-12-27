trigger competitorTrigger on Competitor__c (after undelete) {
    if(Trigger.isAfter && Trigger.isUndelete) {
        CompetitorTriggerHandler.onAfterUndelete(trigger.new);
    }
}