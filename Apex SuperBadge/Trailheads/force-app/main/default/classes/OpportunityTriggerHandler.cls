public with sharing class OpportunityTriggerHandler {
    public static void createTaskonClosedWon(List<Opportunity> newOpportunities) {
        List<Task> tasks = new List<Task>();
        for(Opportunity opp : newOpportunities) {
            if(opp.StageName == 'Closed Won') {
                Task t = new Task();
                t.Subject = 'Follow Up Test Task';
                t.WhatId = opp.Id;
                t.ActivityDate = Date.today();
                tasks.add(t);
            }
        }
        Database.insert(tasks);
    }
}