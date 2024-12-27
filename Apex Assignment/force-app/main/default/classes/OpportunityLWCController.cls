public with sharing class OpportunityLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return [Select Id, Name, StageName, Type from Opportunity LIMIT 5];
    }
    @AuraEnabled
    public static ContactLeadWrappper getContactLeads(String email) {
        List<Contact> contacts = [Select Id, Name, Email from Contact WHere Email=:email];
        List<Lead> leads = [Select Id, Name, Email from Lead WHere Email=:email];
        ContactLeadWrappper conLeadWrap = new ContactLeadWrappper(contacts, leads);
        return conLeadWrap;
    }
    public class ContactLeadWrappper {
        @AuraEnabled public List<Contact> contacts;
        @AuraEnabled public List<Lead> leads;
        ContactLeadWrappper(List<Contact> contacts, List<Lead> leads) {
            this.contacts = contacts;
            this.leads = leads;
        }
    }
}