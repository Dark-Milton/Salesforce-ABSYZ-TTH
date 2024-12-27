public with sharing class GameResult {
    public static void game() {
        List<Game__c> gameList = [SELECT Id, Name, Player_1__c, Player_2__c, Status__c FROM Game__c WHERE Player_1__c != NULL AND Player_2__c != NULL AND Status__c = NULL];
        for(Game__c game: gameList) {
            if(game.Player_1__c == game.Player_2__c) {
                game.Status__c = 'Draw';
            } else if((game.Player_1__c == 'Rock' && game.Player_2__c == 'Scissor') || (game.Player_1__c == 'Scissor' && game.Player_2__c == 'Paper') || (game.Player_1__c == 'Paper' && game.Player_2__c == 'Rock')) {
                game.Status__c = 'Player 1 Wins';
            } else {
                game.Status__c = 'Player 2 Wins';
            }
        }
        update gameList;
        
    }
}