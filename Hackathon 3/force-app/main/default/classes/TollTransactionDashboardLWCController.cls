public with sharing class TollTransactionDashboardLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Toll_Transaction__c> getTollRecords() {
        List<Toll_Transaction__c> tollRecList = [Select Id, Name, Vehicle__r.Name, Vehicle__r.Vehicle_Type__c, Plaza__r.Name, Transaction_Date__c, Amount_Charged__c from Toll_Transaction__c];
        return tollRecList;
    }
    @AuraEnabled(cacheable=true)
    public static List<Toll_Transaction__c> getTollRecordsWithFilter(Datetime startDate, Datetime endDate, String vehicleType, Decimal transactionAmount) {
        System.debug('Hii ' + startDate + endDate + vehicleType + transactionAmount);
        Boolean filter=false;
        String query  = 'Select Id, Name, Vehicle__r.Name, Vehicle__r.Vehicle_Type__c, Plaza__r.Name, Transaction_Date__c, Amount_Charged__c from Toll_Transaction__c';
        // String query1  = 'Select Id, Name, Vehicle__r.Name, Vehicle__r.Vehicle_Type__c, Plaza__r.Name, Transaction_Date__c, Amount_Charged__c from Toll_Transaction__c where (Transaction_Date__c >= :startDate and Transaction_Date__c <= :endDate) or Vehicle__r.Vehicle_Type__c=: vehicleType and Amount_Charged__c=: transactionAmount';
        if(startDate != null && endDate != null) {
            if(filter) query += ' and ';
            else query += ' where ';
            query += '(Transaction_Date__c >= :startDate and Transaction_Date__c <= :endDate)';
            filter = true;
        }
        if(!String.isBlank(vehicleType)) {
            if(filter) query += ' and ';
            else query += ' where ';
            query += 'Vehicle__r.Vehicle_Type__c=: vehicleType';
            filter = true;
        }
        if(transactionAmount != null) {
            if(filter) query += ' and ';
            else query += ' where ';
            query += 'Amount_Charged__c=: transactionAmount';
            filter = true;
        }
        List<Toll_Transaction__c> tollRecList = Database.query(query);
        return tollRecList;
    }
}