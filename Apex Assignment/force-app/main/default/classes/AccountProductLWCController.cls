public with sharing class AccountProductLWCController {
    static Boolean listContains(Object[] source, Object target) {
        return (new Set<Object>(source)).contains(target);
    }
    @AuraEnabled(cacheable=true)
    public static List<Product2> getAllProducts(){
        return [SELECT Id, Name, ProductCode FROM Product2];
    }
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductsByAccountId(Id accountId){
        return [SELECT Id, Name, ProductCode FROM Product2 WHERE Id IN (SELECT Product__c FROM Account_Product__c WHERE Account__c = :accountId)];
    }
    @AuraEnabled(cacheable=false)
    public static void createAccountProductsByAccountIdAndProductId(Id accountId, List<Product2> products){
        List<Account_Product__c> accountProducts = new List<Account_Product__c>();
        List<Product2> existingProducts = getProductsByAccountId(accountId);
        for(Product2 product : products){
            if(AccountProductLWCController.listContains(existingProducts, product)){
                continue;
            }
            Account_Product__c accountProduct = new Account_Product__c();
            accountProduct.Account__c = accountId;
            accountProduct.Product__c = product.Id;
            accountProduct.Name = product.Name;
            accountProducts.add(accountProduct);
        }
        if(!accountProducts.isEmpty()){
            Database.insert(accountProducts);
        }
    }
}