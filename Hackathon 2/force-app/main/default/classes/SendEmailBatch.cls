public class SendEmailBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // A variable to keep track of the total number of wins
    public Id Team1;
    public Id Team2;
    public String Team1Name;
    public String Team2Name;
    public Integer NoOfWins1over2 = 0;
    public Integer NoOfWins2over1 = 0;
    
    // The start method where the query for records is defined
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for the records you want to process
        Match__c match = [Select Home_Team__c, Home_Team__r.Name, Away_Team__c, Away_Team__r.Name from Match__c Where Match_Date__c=Today Limit 1];
        this.Team1 = match.Home_Team__c;
        this.Team2 = match.Away_Team__c;
        this.Team1Name = match.Home_Team__r.Name;
        this.Team2Name = match.Away_Team__r.Name;
        String query = 'Select Id, Name, Winner__C, Home_Team__c, Away_Team__c from Match__c Where Match_Status__c = \'Completed\' and (Home_Team__c =\'' + this.Team1 + '\' or Away_Team__c=\'' + this.Team2 + '\' or Home_Team__c=\'' + this.Team2 + '\' or Away_Team__c=\'' + this.Team1 + '\')';
        return Database.getQueryLocator(query);
    }

    // The execute method where records are processed in batches
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        
        // Business logic to process the records, Calculate wins
        for (SObject record : scope) {
            Match__c match = (Match__c) record;
            if(match.Winner__c == this.Team1) this.NoOfWins1over2 += 1;
            else this.NoOfWins2over1 += 1;
        }
    }

    // The finish method where you can log the total number of records processed and send emails
    public void finish(Database.BatchableContext bc) {
        // Log the total number of processed records
        System.debug('The total number of wins for Team 1 against Team 2: ' + this.NoOfWins1over2);
        System.debug('The total number of wins for Team 2 against Team 1: ' + this.NoOfWins2over1);

        //Get email of IPL manager
        User iplManagerUser = [Select Id, Email from User Where Name='IPL Manager 1' Limit 1];

        // You can also notify users or send emails with the result
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Match Status is Completed');
        mail.setToAddresses(new String[] { iplManagerUser.Email });
        mail.setPlainTextBody('The total number of wins for '+ this.Team1Name +' against Team 2: ' + this.NoOfWins1over2 + '; The total number of wins for '+ this.Team2Name +' against Team 1: ' + this.NoOfWins2over1);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}