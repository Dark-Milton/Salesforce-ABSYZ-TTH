public with sharing class AddPrimaryContact implements Queueable {
    private Contact con;
    private String state;
    public AddPrimaryContact(Contact con, String state) {
        this.con = con;
        this.state = state;
    }
    public void execute(QueueableContext context) {
        List<Account> accounts = [Select Id, Name, BillingState from Account where BillingState = :this.state limit 200];
        List<Contact> conList = new List<Contact>();
        for(Account acc: accounts) {
            Contact c = this.con.clone(false, false, false, false);
            c.AccountId = acc.Id;
            conList.add(c);
        }
        Database.insert(conList);
    }
}