public with sharing class HelloWorld {
    public HelloWorld() {
        System.debug('Hello World!');
    }
    public void smallestNumberInList() {
        List<Integer> listVar = new List<Integer>{1, 2, 3, 4, 5};
        listVar.sort();
        System.debug('Smallest ' + listVar[0]);
    }
    public void SearchKeyInList() {
        List<String> listVar = new List<String>{'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'};
        String keyVar = 'Banana';
        Integer index = listVar.indexOf(keyVar);
        if(index == -1) System.debug('Key Element Not found');
        else System.debug('Location of Key ' + keyVar + ' is ' + index);
    }
    public void CountStringsInList() {
        List<String> listVar = new List<String>{'Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'};
        Integer count = listVar.size();
        System.debug('Number of Strings in the list: ' + count);
    }
    public void InsertAccountRecords(){
        List<Account> accList = new List<Account>();
        for(Integer i = 1; i <= 10; i++){
            Account acc = new Account();
            acc.Name = 'Test Account';
            accList.add(acc);
        }
        insert accList;
    }
    public void UpdateAccountRecords(){
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        for(Account acc : accList){
            acc.Industry = 'Education';
            acc.Type = 'Installation Partner';    
        }
        update accList;
    }
    public void AccountAndContacts() {
        Map<Account, List<Contact>> accConMap = new Map<Account, List<Contact>>();
        List<Account> accList = [SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account];
        for(Account acc : accList){
            accConMap.put(acc, acc.Contacts);
        }
        for(Account acc : accConMap.keySet()){
            System.debug('Account Name: ' + acc.Name);
            List<Contact> conList = accConMap.get(acc);
            for(Contact con : conList){
                System.debug('Contact Name: ' + con.Name);
            }
            System.debug('---');
        }
    }
    public void InsertAccountOpportunity() {
        Account acc = new Account();
        acc.Name = 'New Test Account';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'New Test Opportunity';
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today().addDays(30);
        // opp.CloseDate = Date.newInstance(2002, 12, 16);
        opp.AccountId = acc.Id;
        insert opp;
    }
    public void DisplayAccountOpportunityContacts() {
        List<Account> accList = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities), (SELECT Id, Name FROM Contacts) FROM Account];
        for(Account acc : accList){
            System.debug('Account Name: ' + acc.Name);
            List<Opportunity> oppList = acc.Opportunities;
            for(Opportunity opp : oppList){
                System.debug('Opportunity Name: ' + opp.Name);
            }
            List<Contact> conList = acc.Contacts;
            for(Contact con : conList){
                System.debug('Contact Name: ' + con.Name);
            }
            System.debug('---');
        }
    }
}