trigger CaseTrigger on Case (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        MaintenanceRequestHelper.createFutureMaintainenceCase(Trigger.newMap, Trigger.oldMap);
    }
}