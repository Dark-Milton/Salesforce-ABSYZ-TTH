import { LightningElement, wire } from 'lwc';
import getContactDetails from '@salesforce/apex/ContactLWCController.getContactDetails'

const COLUMNS = [
    { label: 'Name', fieldName: "Name", type: 'text' },
    { label: 'Title', fieldName: "Title", type: 'text' },
    { label: 'Phone', fieldName: "Phone", type: 'tel' },
    { label: 'Email', fieldName: "Email", type: 'email' }
];

export default class AllContactDetails extends LightningElement {
    columns=COLUMNS
    @wire(getContactDetails)
    allContactDetails
}