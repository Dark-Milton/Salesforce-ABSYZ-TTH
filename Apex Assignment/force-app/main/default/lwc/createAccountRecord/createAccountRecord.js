import { api, LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateAccountRecord extends LightningElement {
    @api accountId
    name=''
    ratingValue=''

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo;

    @wire(getPicklistValues, { recordTypeId: '$accountInfo.data.defaultRecordTypeId', fieldApiName: RATING_FIELD })
    RatingPicklistValues

    handleChange(event) {
        if(event.target.name === 'name') this.name=event.detail.value
        if(event.target.name === 'rating') this.ratingValue=event.detail.value
    }

    async handleSubmit(event) {
        event.preventDefault();
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[RATING_FIELD.fieldApiName] = this.ratingValue;

        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };

        try {
            const account = await createRecord(recordInput);
            console.log('Account Created...', account)
            this.accountId = account.id
            const toast = new ShowToastEvent({
                title: 'Account Created',
                variant: 'success',
                message:
                    'Account has been created',
            });
            this.dispatchEvent(toast);
            this.name=''
            this.ratingValue=''
        } catch (error) {
            // Handle error
            console.log(error.message)
            const toast = new ShowToastEvent({
                title: 'Something went wrong',
                variant: 'error',
                message:
                    'Account creation failed',
            });
            this.dispatchEvent(toast);
        }
    }
}