import { LightningElement } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import ACCOUNT_NUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';
import SITE_FIELD from '@salesforce/schema/Account.Site';
import ANNUAL_REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateAccountForToast extends LightningElement {
    fields = [NAME_FIELD, PHONE_FIELD, ACCOUNT_NUMBER_FIELD, SITE_FIELD, ANNUAL_REVENUE_FIELD];

    handleSuccess(event) {
        const ev = new ShowToastEvent({
            title: 'Account Created',
            variant: 'success',
            message:
                'Account is created successfully',
        });
        this.dispatchEvent(ev);
    }
    handleError(event) {
        const ev = new ShowToastEvent({
            title: 'Something went wrong',
            variant: 'error',
            message:
                'Account creation failed',
        });
        this.dispatchEvent(ev);
    }
    handleSubmit(event) {
        if(event.detail.fields.AccountNumber === null) {
            event.preventDefault();
            const errorEvent = new CustomEvent('error', {
                detail: {
                    message: 'Account creation failed: The Name field is required.'
                }
            });
            this.template.querySelector('lightning-record-form').dispatchEvent(errorEvent);
        }
    }
}