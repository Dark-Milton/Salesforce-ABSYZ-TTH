import { LightningElement } from 'lwc';

import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateContactForToast extends LightningElement {
    fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, EMAIL_FIELD, PHONE_FIELD];

    handleSuccess(event) {
        const ev = new ShowToastEvent({
            title: 'Contact Created',
            variant: 'success',
            message:
                'Contact is created successfully',
        });
        this.dispatchEvent(ev);
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
        if(event.detail.fields.Email === null) {
            event.preventDefault();
            const errorEvent = new CustomEvent('error', {
                detail: {
                    message: 'Contact creation failed: The Email field is required.'
                }
            });
            this.template.querySelector('lightning-record-form').dispatchEvent(errorEvent);
        }
    }
}