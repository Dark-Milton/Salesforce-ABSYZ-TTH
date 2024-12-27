public with sharing class leadTriggerHandler {
    public static void onLeadInsert(List<Lead> newLeadRecords) {
        List<Account> accList = new List<Account>();
        Map<Id, Account> accNameMap = new Map<Id, Account>();
        for(Lead lead: newLeadRecords) {
            Account acc = new Account(
                Name = lead.Company,
                Industry = lead.Industry,
                BillingStreet = lead.Street,
                BillingCity = lead.City,
                BillingState = lead.State,
                BillingPostalCode = lead.PostalCode,
                BillingCountry = lead.Country
            );
            accNameMap.put(lead.Id, acc);
            accList.add(acc);
        }

        Database.insert(accList);

        List<Contact> conList = new List<Contact>();
        for(Lead lead: newLeadRecords) {
            Contact con = new Contact(
                FirstName = lead.FirstName,
                LastName = lead.LastName,
                Email = lead.Email,
                Phone = lead.Phone,
                AccountId = accNameMap.get(lead.Id).Id
            );
            conList.add(con);
        }

        Database.insert(conList);

    }
    public static void onInsertConvertLead(List<Lead> newLeadRecords) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        for(Lead lead: newLeadRecords) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(lead.Id);
            lc.setDoNotCreateOpportunity(true);
            lc.setConvertedStatus('Closed - Converted');
            leadConverts.add(lc);
        }
        Database.convertLead(leadConverts);
    }
}