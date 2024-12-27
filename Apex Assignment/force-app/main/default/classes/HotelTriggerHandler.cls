public with sharing class HotelTriggerHandler {
    public static void createHotelReservForActiveContactsAfterInsert(List<Hotel__c> hotelRecords) {
        List<Hotel_Reservation__c> reservationsToCreate = new List<Hotel_Reservation__c>();

        for (Hotel__c hotel : hotelRecords) {
            if (hotel.Associated_Account__c != null) {
                List<Contact> activeContacts = [SELECT Id, Name FROM Contact WHERE AccountId = :hotel.Associated_Account__c AND Active__c = true];

                for (Contact contact : activeContacts) {
                    Hotel_Reservation__c reservation = new Hotel_Reservation__c(
                        Name = contact.Name + ' Reservation',
                        Hotel__c = hotel.Id,
                        Associated_Contact__c = contact.Id,
                        Status__c = 'Reserved'
                    );
                    reservationsToCreate.add(reservation);
                }
            }
        }
        if (!reservationsToCreate.isEmpty()) {
            Database.SaveResult[] srList = Database.insert(reservationsToCreate, false);
            for (Database.SaveResult sr : srList) {
                if (!sr.isSuccess()) {               
                    // for(Database.Error err : sr.getErrors()) {
                    //     System.debug('The following error has occurred.');                    
                    //     System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    //     System.debug('Account fields that affected this error: ' + err.getFields());
                    // }
                    // Database.Error err= sr.getErrors().get(0).getMessage
                    for(Hotel__c hotel: hotelRecords) {
                        hotel.addError(sr.getErrors().get(0).getMessage());
                    }
                }
            }
        }

    }
}