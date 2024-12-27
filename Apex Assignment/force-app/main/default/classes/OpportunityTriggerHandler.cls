public with sharing class OpportunityTriggerHandler {
    public static void onBeforeDelete(List<Opportunity> opportunityRecords) {
        List<Competitor__c> relatedCompetitorList = [Select Id, Name from Competitor__c Where Opportunity__c IN:opportunityRecords];
        Database.delete(relatedCompetitorList);
    }
}