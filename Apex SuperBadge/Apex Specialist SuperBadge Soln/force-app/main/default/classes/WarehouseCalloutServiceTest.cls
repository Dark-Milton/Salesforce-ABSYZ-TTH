@isTest
public with sharing class WarehouseCalloutServiceTest {
    @isTest
    public static void testWarehouseCalloutService() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
            WarehouseCalloutService.getEquipmentUpdates();
        Test.stopTest();
        System.assertEquals(2, [SELECT count() FROM Product2]);
    }
}