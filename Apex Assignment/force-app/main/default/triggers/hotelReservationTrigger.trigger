trigger hotelReservationTrigger on Hotel_Reservation__c (before insert, before update, after update, before delete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        HotelReservationTriggerHandler.countOfHotelReservations(trigger.new, null);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        HotelReservationTriggerHandler.countOfHotelReservations(trigger.new, trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate) {
        HotelReservationTriggerHandler.decreaseCount(trigger.new, trigger.oldMap);
    }
    if(Trigger.isBefore && Trigger.isDelete) {
        HotelReservationTriggerHandler.onHotelReservDelete(trigger.old);
    }
}