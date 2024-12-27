public with sharing class createTaskToReviewOpenOpportunity implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Task> taskList = new List<Task>();
        List<Opportunity> oppList = [SELECT Id, Name, OwnerId FROM Opportunity WHERE StageName = 'Open'];
        for(Opportunity opp : oppList){
            Task t = new Task();
            t.Subject = 'Review Opportunity';
            t.WhatId = opp.Id;
            t.OwnerId = opp.OwnerId;
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            taskList.add(t);
        }
        insert taskList;
    }  
    // Method to schedule the job
    public static void scheduleJob() {
        String cronExpression = '0 0 9 ? * MON *'; 
        System.schedule('TAsk to Review Open Opportunity', cronExpression, new createTaskToReviewOpenOpportunity());
    }
}