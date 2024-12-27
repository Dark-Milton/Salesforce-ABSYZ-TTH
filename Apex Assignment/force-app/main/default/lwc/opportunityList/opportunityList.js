import { LightningElement, wire } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityLWCController.getOpportunities'
import getContactLeads from '@salesforce/apex/OpportunityLWCController.getContactLeads'

const COLUMNS = [
    { label: 'Name', fieldName: "Name", type: 'text' },
    { label: 'Stage Name', fieldName: "StageName", type: 'text' },
    { label: 'Type', fieldName: "Type", type: 'text' }
];

export default class OpportunityList extends LightningElement {
    columns = COLUMNS;
    returnedContacts =[]
    returnedLeads =[]
    modifiedOpportunities

    @wire(getOpportunities)
    returnedOpportunitiesList

    @wire(getOpportunities)
    returnedOpportunities({data, error}) {
        if(data) {
            this.modifiedOpportunities = data.map(opp => ({
                ...opp,
                Name: opp.Name + ' Modified'
            }));
            // let opportunities = [];
            // data.forEach(ele => {
            //     let opp = {};
            //     opp.Name = ele.Name + " Modified";
            //     opp.StageName = ele.StageName;
            //     opportunities.push(opp);
            // });
            // this.modifiedOpportunities = opportunities; 
        }
        if(error) {
        }
    };

    async callContactsAndLaeds() {
        let res = await getContactLeads({email: "test@test.com"})
        console.log(res)
        this.returnedContacts = res.contacts;
        this.returnedLeads = res.leads;
    }

}