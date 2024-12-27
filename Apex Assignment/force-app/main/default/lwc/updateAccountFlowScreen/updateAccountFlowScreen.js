import { api, LightningElement } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class UpdateAccountFlowScreen extends LightningElement {
    @api recordId
    nameField=NAME_FIELD

    handleSuccess(event) {
        const ev = new ShowToastEvent({
            title: 'Account Updated',
            variant: 'success',
            message:
                'Account is updated successfully',
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
                'Account updation failed',
        });
        this.dispatchEvent(ev);
    }
}