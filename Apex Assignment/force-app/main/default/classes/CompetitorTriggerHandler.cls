public with sharing class CompetitorTriggerHandler {
    public static void onAfterUndelete(List<Competitor__c> unDeletedrecords) {
        List<Competitor__c> clonedRecords = new List<Competitor__c>();
        for(Competitor__c comp: unDeletedrecords) {
            Competitor__c newComp = new Competitor__c(Id=comp.Id);
            newComp.Undeleted_Record__c = true;
            clonedRecords.add(newComp);
        }
        Database.update(clonedRecords);
    }
}