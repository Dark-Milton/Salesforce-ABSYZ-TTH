import { LightningElement, wire } from 'lwc';
import getAllAccounts from '@salesforce/apex/AccountLWCController.getAllAccounts'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateRelatedContactRecord extends LightningElement {
    error
    accountOptions = []
    accountId
    isCreated = false

    connectedCallback() {
        this.getAllAccountsData();
    }
    async getAllAccountsData() {
        try {
            let allAccounts = await getAllAccounts();
            this.accountOptions = allAccounts.map((acc) => ({label: acc.Name, value: acc.Id }))
            this.error = undefined;
        } catch (error) {
            this.allAccounts = undefined;
            this.error = error;
        }
    }

    handleSubmit(event) {
        event.preventDefault();
        event.detail.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);

    }
    handleChange(event) {
        this.accountId = event.detail.value;
    }

    handleSuccess(event) {
        this.isCreated=true
        console.log("Hii contact created")
        const toast = new ShowToastEvent({
            title: 'Contact Created',
            variant: 'success',
            message:
                'Contact is created successfully.',
        });
        this.dispatchEvent(toast);
        setTimeout(() => {
            this.isCreated = false
        }, 2000)
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        inputFields.forEach( field => {
            field.reset();
        })
        this.accountId = null
    }
}