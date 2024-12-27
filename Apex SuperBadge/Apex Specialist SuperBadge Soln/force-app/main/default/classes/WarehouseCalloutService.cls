public with sharing class WarehouseCalloutService implements Queueable {
    @future(callout=true)
    public static void getEquipmentUpdates() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.132504654.1594494759.1731560089-188285544.1731560089');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<Product2> warehouseEq = new List<Product2>();
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for(Object result: results) {
                Map<String,Object> equipment = (Map<String,Object>)result;
                Product2 myEq = new Product2();
                myEq.Replacement_Part__c = true;
                myEq.Name = (String) equipment.get('name');
                myEq.Maintenance_Cycle__c = (Integer) equipment.get('maintenanceperiod');
                myEq.Lifespan_Months__c = (Integer) equipment.get('lifespan');
                myEq.Cost__c = (Integer) equipment.get('cost');
                myEq.Warehouse_SKU__c = (String) equipment.get('sku');
                myEq.Current_Inventory__c = (Double) equipment.get('quantity');
                myEq.ProductCode = (String) equipment.get('_id');
                warehouseEq.add(myEq);
            }
            if(!warehouseEq.isEmpty()) {
                Database.upsert(warehouseEq);
            }
        }
    }
    public void execute(QueueableContext context) {
        WarehouseCalloutService.getEquipmentUpdates();
    }
}