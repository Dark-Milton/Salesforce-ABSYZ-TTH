trigger hotelTrigger on Hotel__c (before insert, after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert) {
        HotelTriggerHandler.createHotelReservForActiveContactsAfterInsert(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isInsert) {
        for(Hotel__c hotel: trigger.new) {
            if(hotel.Current_Seating_Capacity__c == null) hotel.Current_Seating_Capacity__c =0;
        }
    }
}