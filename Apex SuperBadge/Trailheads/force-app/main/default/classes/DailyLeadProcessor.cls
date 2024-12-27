public class DailyLeadProcessor implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id, Name, LeadSource FROM Lead WHERE LeadSource = null limit 200];
        for (Lead lead : leads) {
            lead.LeadSource = 'Dreamforce';
        }
        Database.update(leads);
    }
}