import { getRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';

export default class ContactDetails extends LightningElement {
    @api recordId
    contactDetails
    contactDetailsKeys

    @wire(getRecord, { recordId: '$recordId', layoutTypes: "Full"})
    contactDetails({ data, error}) {
        if(data) {
            this.contactDetails = data.fields
            this.contactDetailsKeys = Object.keys(this.contactDetails)
            console.log("Contact Data", this.contactDetailsKeys);
        }
        console.log("Here")
    }
}