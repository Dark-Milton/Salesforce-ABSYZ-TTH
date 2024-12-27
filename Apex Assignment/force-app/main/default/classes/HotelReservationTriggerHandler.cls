public with sharing class HotelReservationTriggerHandler {
    public static void countOfHotelReservations(List<Hotel_Reservation__c> hotelResRecords, Map<Id, Hotel_Reservation__c> oldHotelResRecordsMap) {
        // Set<Id> hotelIds = new Set<id>();

        // for(Hotel_Reservation__c hotelRes: hotelResRecords) {
        //     hotelIds.add(hotelRes.Hotel__c);
        // }

        // List<Hotel__c> hotelRecords = [Select Id, Name, Current_Seating_capacity__c, (Select Id from Hotel_Reservations__r Where Status__c = 'Reserved') from Hotel__c Where Id In:hotelIds];

        // for(Hotel__c hotel: hotelRecords) {
        //     hotel.Current_Seating_capacity__c = hotel.Hotel_Reservations__r.size();
        // }

        // Database.update(hotelRecords);

        Map<Id, Integer> newHotelReservations = new Map<Id, Integer>();

        for (Hotel_Reservation__c hotelReserv : hotelResRecords) {
            if (hotelReserv.Status__c == 'Reserved') {
                if (hotelReserv.Id == null || oldHotelResRecordsMap.get(hotelReserv.Id).Status__c != hotelReserv.Status__c) {
                    if (newHotelReservations.containsKey(hotelReserv.Hotel__c)) {
                        newHotelReservations.put(hotelReserv.Hotel__c, newHotelReservations.get(hotelReserv.Hotel__c) + 1);
                    } else {
                        newHotelReservations.put(hotelReserv.Hotel__c, 1);
                    }
                }
            }
        }

        Map<Id, Hotel__c> hotelMap = new Map<Id, Hotel__c>([Select Id, Name, Current_Seating_Capacity__c, Maximum_Capacity__c FROM Hotel__c WHERE Id = :newHotelReservations.keySet()]);
        for (Id hotelId : hotelMap.keySet()) {
            Hotel__c hotel = hotelMap.get(hotelId);
        
            if (hotel.Current_Seating_Capacity__c + newHotelReservations.get(hotelId) > hotel.Maximum_Capacity__c) {
                for (Hotel_Reservation__c reservation : hotelResRecords) {
                    if (reservation.Hotel__c == hotelId && reservation.Status__c == 'Reserved') {
                        reservation.addError('The seating capacity exceeded max');
                    }
                }
            }
            else {
                hotel.Current_Seating_Capacity__c = hotel.Current_Seating_Capacity__c + newHotelReservations.get(hotelId);
                hotelMap.put(hotelId, hotel);
            }
        }
        Database.update(hotelMap.values());
        // for(Hotel_Reservation__c reservation : hotelResRecords) {
        //     if (reservation.Status__c == 'Reserved') {
        //         Hotel__c hotel =  hotelMap.get(reservation.Hotel__c);
        //         if (hotel.Current_Seating_Capacity__c + newHotelReservations.get(reservation.Hotel__c) > hotel.Maximum_Capacity__c) {
        //             reservation.addError('The seating capacity exceeded max');
        //         }
        //     }
        // }
    }
    public static void onHotelReservDelete(List<Hotel_Reservation__c> hotelResRecords) {
        Set<Id> hotelIds = new Set<Id>();

        for (Hotel_Reservation__c hotelRes : hotelResRecords) {
            hotelIds.add(hotelRes.Hotel__c);
        }

        List<Hotel__c> hotelRecords = [SELECT Id, Name, Current_Seating_Capacity__c, (Select Id, Name from Hotel_Reservations__r Where Id in:hotelResRecords) FROM Hotel__c WHERE Id IN :hotelIds];

        for (Hotel__c hotel : hotelRecords) {
            hotel.Current_Seating_Capacity__c = hotel.Current_Seating_Capacity__c - hotel.Hotel_Reservations__r.size();
        }

        Database.update(hotelRecords);
    }
    public static void decreaseCount(List<Hotel_Reservation__c> hotelResRecords, Map<Id, Hotel_Reservation__c> oldHotelResRecordsMap) {
        Map<Id, Integer> newHotelReservations = new Map<Id, Integer>();

        for (Hotel_Reservation__c hotelReserv : hotelResRecords) {
            System.debug(hotelReserv.Status__c);
            if (hotelReserv.Status__c == 'Cancelled') {
                if (hotelReserv.Id == null || oldHotelResRecordsMap.get(hotelReserv.Id).Status__c != hotelReserv.Status__c) {
                    if (newHotelReservations.containsKey(hotelReserv.Hotel__c)) {
                        newHotelReservations.put(hotelReserv.Hotel__c, newHotelReservations.get(hotelReserv.Hotel__c) + 1);
                    } else {
                        newHotelReservations.put(hotelReserv.Hotel__c, 1);
                    }
                }
            }
        }


        Map<Id, Hotel__c> hotelMap = new Map<Id, Hotel__c>([Select Id, Name, Current_Seating_Capacity__c, Maximum_Capacity__c FROM Hotel__c WHERE Id = :newHotelReservations.keySet()]);
        for (Id hotelId : hotelMap.keySet()) {
            Hotel__c hotel = hotelMap.get(hotelId);
            hotel.Current_Seating_Capacity__c = hotel.Current_Seating_Capacity__c - newHotelReservations.get(hotelId);
            hotelMap.put(hotelId, hotel);
        }
        
        Database.update(hotelMap.values());
    }
}