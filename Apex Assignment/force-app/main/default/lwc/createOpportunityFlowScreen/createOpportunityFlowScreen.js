import { api, LightningElement } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';
import STAGE_NAME_FIELD from '@salesforce/schema/Opportunity.StageName';
import CLOSE_DATE_FIELD from '@salesforce/schema/Opportunity.CloseDate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class CreateOpportunityFlowScreen extends LightningElement {
    @api accountId
    fields = [NAME_FIELD, STAGE_NAME_FIELD, CLOSE_DATE_FIELD];

    handleSuccess(event) {
        const ev = new ShowToastEvent({
            title: 'Opportunity Created',
            variant: 'success',
            message:
                'Opportunity is created successfully',
        });
        this.dispatchEvent(ev);
        const finishFlow = new FlowNavigationFinishEvent();
        this.dispatchEvent(finishFlow);
    }
    handleError(event) {
        const ev = new ShowToastEvent({
            title: 'Something went wrong',
            variant: 'error',
            message:
                'Opportunity creation failed',
        });
        this.dispatchEvent(ev);
    }
    handleSubmit(event) {
        event.preventDefault();
        event.detail.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-form').submit(event.detail.fields);
    }
}