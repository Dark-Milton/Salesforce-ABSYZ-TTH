import { LightningElement, track } from 'lwc';
import getContactsBasedOnType from '@salesforce/apex/AccountLWCController.getContactsBasedOnType'
import FirstName from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Email from '@salesforce/schema/Contact.Email';
import Phone from '@salesforce/schema/Contact.Phone';

const COLUMNS = [
    { label: 'First Name', fieldName: FirstName.fieldApiName, type: 'text' },
    { label: 'Last Name', fieldName: LastName.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: Email.fieldApiName, type: 'email' },
    { label: 'Phone', fieldName: Phone.fieldApiName, type: 'tel' }
];

export default class FilteredContactsOnAccountType extends LightningElement {
    @track allRecords
    @track filteredContacts =[]

    columns = COLUMNS;
    value = '';

    get options() {
        return [
            { label: 'Public', value: 'Public' },
            { label: 'Private', value: 'Private' },
            { label: 'Subsidiary', value: 'Subsidiary' },
            { label: 'Other', value: 'Other' },
        ];
    }
    async getFilteredContacts(type) {
        try {
            this.allRecords = await getContactsBasedOnType({type: type});
            // this.filteredContacts = []
            // this.allRecords.map(acc => {
            //     acc.Contacts.map(con => {
            //         this.filteredContacts.push(con)
            //     })
            // })
            this.filteredContacts = this.allRecords.map(acc => {
                return acc.Contacts;
            })
            this.filteredContacts = this.filteredContacts.flat()
            this.error = undefined;
        } catch (error) {
            this.allRecords = undefined;
            this.filteredContacts = undefined;
            this.error = error;
            console.log(JSON.stringify(error.message))
        }
    }

    handleChange(e) {
        this.value = e.detail.value;
        console.log("In Handle Submit, ", e.detail.value)
        this.getFilteredContacts(e.detail.value)
    }
}