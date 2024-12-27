@IsTest 
private class AccountTestClass {
    @IsTest
    static void valiateAccountTrigger() {
        Account acc = new Account(Name='Some Account Name', Industry='Agriculture');
       System.debug('Rating before inserting new account: ' + acc.Rating);

       insert acc;
    
       acc = [SELECT Id, Name, Industry, Rating FROM Account WHERE Id =:acc.Id];
       System.debug('Rating after inserting new account: ' + acc.Rating);

       System.assertEquals('Hot', acc.Rating);
    }
}