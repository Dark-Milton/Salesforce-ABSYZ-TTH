trigger movieTrigger on Movie__c (after insert, after update) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        List<Movie__c> movieList = [Select Id, Director__r.Email, All_actors_are_available__c from Movie__c Where Id in:trigger.new];
        Messaging.SingleEmailMessage[] mailList = new Messaging.SingleEmailMessage[]{};
        for(Movie__c movie: movieList) {
            if((Trigger.isInsert || trigger.oldMap.get(movie.Id).All_actors_are_available__c != movie.All_actors_are_available__c) && movie.All_actors_are_available__c && movie.Director__c != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {movie.Director__r.Email};
                System.debug(movie.Director__r.Email);
                mail.setToAddresses(toAddresses);
                mail.setSubject('All Actors are available');
                mail.setPlainTextBody('This email is to let you kow that all the actors associated with your movie are available at the moment.');
                mailList.add(mail);
            }
        }
        Messaging.sendEmail(mailList);
    }
}