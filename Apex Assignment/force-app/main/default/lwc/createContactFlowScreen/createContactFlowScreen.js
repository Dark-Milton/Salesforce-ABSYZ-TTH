import { api, LightningElement } from 'lwc';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class CreateContactFlowScreen extends LightningElement {
    @api accountId
    fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, EMAIL_FIELD, PHONE_FIELD];

    handleSuccess(event) {
        const ev = new ShowToastEvent({
            title: 'Contact Created',
            variant: 'success',
            message:
                'Contact is created successfully',
        });
        this.dispatchEvent(ev);
        const navigateNext = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNext);
    }
    handleError(event) {
        const ev = new ShowToastEvent({
            title: 'Something went wrong',
            variant: 'error',
            message:
                'Contact creation failed',
        });
        this.dispatchEvent(ev);
    }
    handleSubmit(event) {
        event.preventDefault();
        event.detail.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-form').submit(event.detail.fields);
    }
}