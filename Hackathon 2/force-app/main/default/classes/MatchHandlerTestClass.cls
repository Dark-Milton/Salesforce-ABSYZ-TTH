@isTest
public with sharing class MatchHandlerTestClass {
    @isTest
    public static void testBeforeUpdate() {
        List<Team__c> teamList = new List<Team__c>();
        for(Integer i=1;i<=2;i++) {
            Team__c team = new Team__c(
                Name='Team '+ i,
                Founded_year__c = 2002
            );
            teamList.add(team);
        }

        insert teamList;

        Venue__c venue = new Venue__c(
            Name='Test Place'
        );

        insert venue;

        Match__c match = new Match__c(
            Name='Test match',
            Home_Team__c = teamList[0].Id,
            Away_Team__c = teamList[1].Id,
            Match_Status__c = 'Scheduled',
            Venue__c = venue.Id,
            Toss_won__c = teamList[0].Id,
            Opt_to__c = 'Batting',            
            Match_Date__c=Date.today()
        );

        insert match;

        List<Player__c> playerList = new List<Player__c>();
        Player__c player1 = new Player__c(
            Name = 'Team 1 Test Player 1',
            Role__c = 'Batsman',
            Team__c = teamList[0].Id,
            Active__c=true
        );
        playerList.add(player1);
        Player__c player2 = new Player__c(
            Name = 'Team 1 Test Player 2',
            Role__c = 'Bowler',
            Team__c = teamList[0].Id,
            Active__c=true
        );
        playerList.add(player2);
        Player__c player3 = new Player__c(
            Name = 'Team 1 Test Player 3',
            Role__c = 'All-rounder',
            Team__c = teamList[0].Id,
            Active__c=true
        );
        playerList.add(player3);
        Player__c player4 = new Player__c(
            Name = 'Team 1 Test Player 4',
            Role__c = 'Batsman',
            Team__c = teamList[0].Id,
            Active__c=true
        );
        playerList.add(player4);
        Player__c player5 = new Player__c(
            Name = 'Team 1 Test Player 5',
            Role__c = 'Bowler',
            Team__c = teamList[0].Id,
            Active__c=true
        );
        playerList.add(player5);


        Player__c player6 = new Player__c(
            Name = 'Team 2 Test Player 1',
            Role__c = 'All-rounder',
            Team__c = teamList[1].Id,
            Active__c=true
        );
        playerList.add(player6);
        Player__c player7 = new Player__c(
            Name = 'Team 2 Test Player 2',
            Role__c = 'Batsman',
            Team__c = teamList[1].Id,
            Active__c=true
        );
        playerList.add(player7);
        Player__c player8 = new Player__c(
            Name = 'Team 2 Test Player 3',
            Role__c = 'Batsman',
            Team__c = teamList[1].Id,
            Active__c=true
        );
        playerList.add(player8);
        Player__c player9 = new Player__c(
            Name = 'Team 2 Test Player 4',
            Role__c = 'Bowler',
            Team__c = teamList[1].Id,
            Active__c=true
        );
        playerList.add(player9);
        Player__c player10 = new Player__c(
            Name = 'Team 2 Test Player 5',
            Role__c = 'Bowler',
            Team__c = teamList[1].Id,
            Active__c=true
        );
        playerList.add(player10);

        insert playerList;


        List<MatchPlayer__c> matchPlayerList = new List<MatchPlayer__c>();
        MatchPlayer__c matchPlayer1 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player1.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 30,
            Number_of_Wickets__c = 1 
        );
        matchPlayerList.add(matchPlayer1);
        MatchPlayer__c matchPlayer2 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player2.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 10,
            Number_of_Wickets__c = 3 
        );
        matchPlayerList.add(matchPlayer2);
        MatchPlayer__c matchPlayer3 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player3.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 45,
            Number_of_Wickets__c = 2 
        );
        matchPlayerList.add(matchPlayer3);
        MatchPlayer__c matchPlayer4 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player4.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 20,
            Number_of_Wickets__c = 1 
        );
        matchPlayerList.add(matchPlayer4);
        MatchPlayer__c matchPlayer5 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player5.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 15,
            Number_of_Wickets__c = 2 
        );
        matchPlayerList.add(matchPlayer5);

        MatchPlayer__c matchPlaye6 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player6.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 30,
            Number_of_Wickets__c = 1 
        );
        matchPlayerList.add(matchPlaye6);
        MatchPlayer__c matchPlaye7 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player7.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 35,
            Number_of_Wickets__c = 1 
        );
        matchPlayerList.add(matchPlaye7);
        MatchPlayer__c matchPlaye8 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player8.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 0,
            Number_of_Wickets__c = 1 
        );
        matchPlayerList.add(matchPlaye8);
        MatchPlayer__c matchPlayer9 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player9.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 30,
            Number_of_Wickets__c = 2 
        );
        matchPlayerList.add(matchPlayer9);
        MatchPlayer__c matchPlayer10 = new MatchPlayer__c(
            Match__c = match.Id,
            Player__c = player10.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 20,
            Number_of_Wickets__c = 3 
        );
        matchPlayerList.add(matchPlayer10);

        insert matchPlayerList;

        match.Match_Status__c = 'Completed';
        match.Winner__c = teamList[0].Id;
        
        update match;
        
        // Test.startTest();

        Match__c actualMatchRecords = [Select Id, Man_of_the_Match__c, Winner__c from Match__c Where ID =:match.Id];
        System.assertEquals(player3.Id, actualMatchRecords.Man_of_the_Match__c, 'Man Of the Match is not as per expected value');

        Venue__c actualVenueRecords = [Select Id, Name, Description__c from Venue__c Where ID =:venue.Id];
        System.assertEquals('1 Matches won by batting first and 0 match won by bowling first', actualVenueRecords.Description__c, 'Description is not as expected');

        // Test.stopTest();

        Match__c match1 = new Match__c(
            Name='Test match1',
            Home_Team__c = teamList[0].Id,
            Away_Team__c = teamList[1].Id,
            Match_Status__c = 'Scheduled',
            Venue__c = venue.Id,
            Toss_won__c = teamList[0].Id,
            Opt_to__c = 'Bowling',
            Match_Date__c=Date.today()
        );

        insert match1;

        List<MatchPlayer__c> matchPlayer1List = new List<MatchPlayer__c>();
        MatchPlayer__c matchPlayer11 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player1.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 30,
            Number_of_Wickets__c = 1
        );
        matchPlayer1List.add(matchPlayer11);
        MatchPlayer__c matchPlayer12 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player2.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 10,
            Number_of_Wickets__c = 3 
        );
        matchPlayer1List.add(matchPlayer12);
        MatchPlayer__c matchPlayer13 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player3.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 45,
            Number_of_Wickets__c = 2 
        );
        matchPlayer1List.add(matchPlayer13);
        MatchPlayer__c matchPlayer14 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player4.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 20,
            Number_of_Wickets__c = 1 
        );
        matchPlayer1List.add(matchPlayer14);
        MatchPlayer__c matchPlayer15 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player5.Id,
            Team__c = teamList[0].Id,
            Number_of_Runs__c = 15,
            Number_of_Wickets__c = 2 
        );
        matchPlayer1List.add(matchPlayer15);

        MatchPlayer__c matchPlayer16 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player6.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 30,
            Number_of_Wickets__c = 1 
        );
        matchPlayer1List.add(matchPlayer16);
        MatchPlayer__c matchPlayer17 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player7.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 35,
            Number_of_Wickets__c = 1 
        );
        matchPlayer1List.add(matchPlayer17);
        MatchPlayer__c matchPlayer18 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player8.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 0,
            Number_of_Wickets__c = 1 
        );
        matchPlayer1List.add(matchPlayer18);
        MatchPlayer__c matchPlayer19 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player9.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 30,
            Number_of_Wickets__c = 2 
        );
        matchPlayer1List.add(matchPlayer19);
        MatchPlayer__c matchPlayer20 = new MatchPlayer__c(
            Match__c = match1.Id,
            Player__c = player10.Id,
            Team__c = teamList[1].Id,
            Number_of_Runs__c = 20,
            Number_of_Wickets__c = 3 
        );
        matchPlayer1List.add(matchPlayer20);
        insert matchPlayer1List;

        match1.Match_Status__c = 'Completed';
        match1.Winner__c = teamList[0].Id;
        
        update match1;

        // Test.startTest();

        Venue__c actualVenueRecords1 = [Select Id, Name, Description__c from Venue__c Where ID =:venue.Id];
        System.assertEquals('1 Matches won by batting first and 1 match won by bowling first', actualVenueRecords1.Description__c, 'Description is not as expected');

        // Test.stopTest();
        match1.Winner__c = teamList[0].Id;
        update match1;

        Database.executeBatch(new SendEmailBatch(), 20);
        SendEmailBatchScheduled.scheduleJob();
    }
}