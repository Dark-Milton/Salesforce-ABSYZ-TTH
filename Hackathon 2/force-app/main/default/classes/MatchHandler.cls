public with sharing class MatchHandler {
    //Getting the Man of the Match from Winning Team of the current Match
    public static void getManOfTheMatch(List<Match__c> matchRecords, Map<Id,Match__c> oldMatchRecordsMap) {
        Map<Id, Match__c> matchMap = new Map<Id, Match__c>();

        //get completed match Ids
        for(Match__c match: matchRecords) {
            if(match.Winner__c != null && match.Match_Status__c == 'Completed' && oldMatchRecordsMap.get(match.Id).Match_Status__c == 'Scheduled')
                matchMap.put(match.Id, match);
        }
        //Id empty return
        if(matchMap.isEmpty()) return;

        Map<Id, MatchPlayer__c> matchPlayerMap = new Map<Id, MatchPlayer__c>([Select Id, Name, Team__c, Match__c, Player__c, Player__r.Name, Player__r.Role__c, Number_of_Runs__c, Number_of_Wickets__c, Match__r.Winner__c, Match__r.Name from MatchPlayer__c Where Match__c in:matchMap.keySet()]);
        Map<Id, Decimal> matchPointsMap = new Map<Id, Decimal>();
        Map<Id, Id> matchNameMap = new Map<Id, Id>();

        
        //Getting custom labels values for Batter and Bowler
        Integer batterPointsFactor = Integer.valueOf(System.label.Batter_Points_Factor);
        Integer bowlerPointsFactor = Integer.valueOf(System.label.Bowler_Points_Factor);

        for(Id matchPlayerId: matchPlayerMap.KeySet()) {
            MatchPlayer__c matchPlayer = matchPlayerMap.get(matchPlayerId);
            Decimal points = 0;

            //Not a Winning Team
            if(matchPlayer.Team__c != matchMap.get(matchPlayer.Match__c).Winner__c) continue;
            
            //Calculate points of MatchPlayer
            if(matchPlayer.Player__r.Role__c == 'Batsman') points = matchPlayer.Number_of_Runs__c!=null? points + (matchPlayer.Number_of_Runs__c * batterPointsFactor): points;
            if(matchPlayer.Player__r.Role__c == 'Bowler') points = matchPlayer.Number_of_Wickets__c!=null? points + (matchPlayer.Number_of_Wickets__c * bowlerPointsFactor): points;
            if(matchPlayer.Player__r.Role__c == 'All-rounder') {
                points = matchPlayer.Number_of_Runs__c!=null? points + (matchPlayer.Number_of_Runs__c * batterPointsFactor): points;
                points = matchPlayer.Number_of_Wickets__c!=null? points + (matchPlayer.Number_of_Wickets__c * bowlerPointsFactor): points;
            }
            

            //Compare points with curr man of the match
            if(matchPointsMap.containsKey(matchPlayer.Match__c) && points != null) {
                if(points > matchPointsMap.get(matchPlayer.Match__c)) {
                    matchPointsMap.put(matchPlayer.Match__c, points);
                    matchNameMap.put(matchPlayer.Match__c, matchPlayer.Player__c);
                }
            }
            else if(points != null) {
                matchPointsMap.put(matchPlayer.Match__c, points);
                matchNameMap.put(matchPlayer.Match__c, matchPlayer.Player__c);
            }
        }

        //Update name of match player
        for(Match__c match: matchMap.values()) {
            if(matchNameMap.containsKey(match.Id)){
                match.Man_of_the_Match__c = matchNameMap.get(match.Id);
            }
        }

    }
    //Update related venure description after match is completed
    public static void updateVenueDescription(List<Match__c> matchRecords, Map<Id,Match__c> oldMatchRecordsMap) {
        Set<Id> venueIds = new Set<Id>();

        //get completed match Ids
        for(Match__c match: matchRecords) {
            if(match.Venue__c!= null && match.Winner__c != null && match.Opt_to__c != null && match.Toss_won__c != null && match.Match_Status__c == 'Completed')
                venueIds.add(match.Venue__c);
        }
        //Id empty return
        if(venueIds.isEmpty()) return;

        //Getting all Matches That are Batting Won and Getting the count for related venue
        List<Match__c> matchListBatting = [Select Id, Name, Winner__c, Toss_won__c, Venue__c from Match__c Where Opt_to__c = 'Batting' and Match_Status__c = 'Completed' and Venue__c in:venueIds];
        Map<Id, Integer> battingWonMap = new Map<Id, Integer>();
        for(Match__c match: matchListBatting) {
            if(match.Winner__c == match.Toss_won__c) {
                if(!battingWonMap.containsKey(match.Venue__c)) battingWonMap.put(match.Venue__c, 0);
                battingWonMap.put(match.Venue__c, battingWonMap.get(match.Venue__c) + 1);
            }
        }

        //Getting all Matches That are Bowling Won and Getting the count for related venue
        List<Match__c> matchListBowling = [Select Id, Name, Winner__c, Toss_won__c, Venue__c from Match__c Where Opt_to__c = 'Bowling' and Match_Status__c = 'Completed' and Venue__c in:venueIds];
        Map<Id, Integer> bowlingWonMap = new Map<Id, Integer>();
        for(Match__c match: matchListBowling) {
            if(match.Winner__c == match.Toss_won__c) {
                if(!bowlingWonMap.containsKey(match.Venue__c)) bowlingWonMap.put(match.Venue__c, 0);
                bowlingWonMap.put(match.Venue__c, bowlingWonMap.get(match.Venue__c) + 1);
            }
        }

        // Updating related venue records
        List<Venue__c> venueToBeUpdated = new List<Venue__c>([Select Id, Name, Description__c from Venue__c Where Id in:venueIds]);
        for(Venue__c venue: venueToBeUpdated) {
            venue.Description__c = battingWonMap.containsKey(venue.Id) ? String.valueOf(battingWonMap.get(venue.Id)) : '0';
            venue.Description__c = venue.Description__c + ' Matches won by batting first and ';
            venue.Description__c = venue.Description__c + (bowlingWonMap.containsKey(venue.Id) ? String.valueOf(bowlingWonMap.get(venue.Id)) : '0');
            venue.Description__c = venue.Description__c +' match won by bowling first';
        }

        //Update venue decriptions
        Database.update(venueToBeUpdated);


    }
}