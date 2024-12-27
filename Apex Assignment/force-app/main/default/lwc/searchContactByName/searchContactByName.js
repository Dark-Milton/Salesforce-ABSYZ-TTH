import { LightningElement, wire } from 'lwc';
import searchContactsByName from '@salesforce/apex/ContactLWCController.searchContactsByName'

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'tel' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];

export default class SearchContactByName extends LightningElement {
    columnsList = COLUMNS
    name=''
    handleChange(event) {
        this.name=event.detail.value
    }
    @wire(searchContactsByName, {name: '$name'})
    contactsList
}