public with sharing class MaintenanceRequestHelper {
    public static void createFutureMaintainenceCase(Map<Id, Case> caseRecordsMap, Map<Id, Case> oldCaseRecordsMap) {
        List<Case> newCasesList = new List<Case>();

        Set<Id> caseIds = new Set<Id>();

        for (Id caseId : caseRecordsMap.keySet()) {
            Case caseRecord = caseRecordsMap.get(caseId);
            if (caseRecord.Status == 'Closed' && oldCaseRecordsMap.get(caseRecord.Id).Status != caseRecord.Status) {
                if(caseRecord.Type == 'Repair' || caseRecord.Type == 'Routine Maintenance') {
                    caseIds.add(caseRecord.Id);
                }
            }
        }

        if(caseIds.isEmpty()) return;


        Map<Id,Decimal> maintenanceCycles = new Map<ID,Decimal>();
        AggregateResult[] results = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)cycle FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN :caseIds GROUP BY Maintenance_Request__c];
        for(AggregateResult ar : results){ 
            maintenanceCycles.put((Id) ar.get('Maintenance_Request__c'), (Decimal) ar.get('cycle'));
        }

        for(Id caseId : caseIds) {
            Case caseRecord = caseRecordsMap.get(caseId);

            Case newCase = new Case();
            newCase.ParentId = caseRecord.Id;
            newCase.Subject = 'Routine Maintenance';
            newCase.Type = 'Routine Maintenance';
            newCase.Status = 'New';
            newCase.Priority = 'Low';
            newCase.Vehicle__c = caseRecord.Vehicle__c;
            newCase.ProductId = caseRecord.ProductId;
            newCase.Date_Reported__c = Date.today();
            If (maintenanceCycles.containskey(caseId)){
                newCase.Date_Due__c = Date.today().addDays(maintenanceCycles.get(caseId).intValue());
            }
            newCasesList.add(newCase);
        }

        if (!newCasesList.isEmpty()) {
            Database.insert(newCasesList);
        }

        List<Equipment_Maintenance_Item__c> clonedWPs = new List<Equipment_Maintenance_Item__c>();
        Map<Id,Case> closedCasesM = new Map<Id,Case>([SELECT Id, Vehicle__c, ProductId, Product.Maintenance_Cycle__c,(SELECT Id,Equipment__c,Quantity__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Id IN :caseIds]);
        for (Case nc : newCasesList){
            for (Equipment_Maintenance_Item__c wp : closedCasesM.get(nc.ParentId).Equipment_Maintenance_Items__r){
                Equipment_Maintenance_Item__c wpClone = wp.clone();
                wpClone.Maintenance_Request__c = nc.Id;
                ClonedWPs.add(wpClone);
                
            }
        }
        if (!ClonedWPs.isEmpty()) {
            Database.insert(ClonedWPs);
        }
    }
}