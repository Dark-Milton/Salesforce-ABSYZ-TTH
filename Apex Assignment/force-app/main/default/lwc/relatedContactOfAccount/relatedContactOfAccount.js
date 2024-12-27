import { api, LightningElement, wire } from 'lwc';
import getAccountRelatedContacts from '@salesforce/apex/ContactLWCController.getAccountRelatedContacts'


export default class RelatedContactOfAccount extends LightningElement {
    @api recordId
    @api objectApiName
    columns
    relatedContacts=[]

    @wire(getAccountRelatedContacts, {accountId: '$recordId'})
    wiredContacts({ data, error }) {
        if (data) {
            this.columns = [
                { label: 'Name', fieldName: "Name", type: 'text' },
                { label: 'Title', fieldName: "Title", type: 'text' },
                { label: 'Phone', fieldName: "Phone", type: 'tel' },
                { label: 'Contact Owner', fieldName: "ContactOwner", type: 'text' },
                { label: 'Emoji', fieldName: "Emoji", type: 'text' },
            ];
            const allEmailsEmpty = data.every(con => !con.Email);
            if(!allEmailsEmpty) this.columns.push({ label: 'Email', fieldName: "Email", type: 'email' })
            this.relatedContacts = data.map((con) => 
                ({...con, ContactOwner: con.Owner.Name, Emoji: '✌🚀'})
            );
        } else if (error) {
            console.error('Error fetching contact details:', error);
        }
    }
}