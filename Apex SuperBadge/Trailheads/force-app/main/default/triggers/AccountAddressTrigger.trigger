trigger AccountAddressTrigger on Account (before insert, before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            AccountTriggerHandler.updateAccountAddress(Trigger.new);
        }
    }
}