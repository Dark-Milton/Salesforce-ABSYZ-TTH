import { api, LightningElement, track } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";
import CONTACT_OBJECT from "@salesforce/schema/Contact";
import FIRST_NAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LAST_NAME_FIELD from "@salesforce/schema/Contact.LastName";
import EMAIL from "@salesforce/schema/Contact.Email";
import PHONE from "@salesforce/schema/Contact.Phone";
import BIRTHDATE from "@salesforce/schema/Contact.Birthdate";
import ACCOUNTID from "@salesforce/schema/Contact.AccountId";

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateRelatedContactPersonal extends LightningElement {
    @api recordId
    @track contactObj = {
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        birthdate: ''
    }
    handleChange = (event) => {
        this.contactObj[event.target.fieldName] = event.detail.value
    }
    handleSubmit = async (event) => {
        event.preventDefault();
        const fields = {};
        fields[FIRST_NAME_FIELD.fieldApiName] = this.contactObj.firstName;
        fields[LAST_NAME_FIELD.fieldApiName] = this.contactObj.lastName;
        fields[EMAIL.fieldApiName] = this.contactObj.email;
        fields[PHONE.fieldApiName] = this.contactObj.phone;
        fields[BIRTHDATE.fieldApiName] = this.contactObj.birthdate;
        fields[ACCOUNTID.fieldApiName] = this.recordId;

        const recordInput = { apiName: CONTACT_OBJECT.objectApiName, fields };

        try {
            const contact = await createRecord(recordInput);
            console.log('Contact Created...', contact)
            const toast = new ShowToastEvent({
                title: 'Contact Created',
                variant: 'success',
                message:
                    'Contact has been created for this account',
            });
            this.dispatchEvent(toast);
            
        } catch (error) {
            // Handle error
            const toast = new ShowToastEvent({
                title: 'Contact Creation failed',
                variant: 'error',
                message:
                    'Contact is not created for this account',
            });
            this.dispatchEvent(toast);
        }
        this.contactObj = {
            firstName: '',
            lastName: '',
            email: '',
            phone: '',
            birthdate: ''
        }
    }
}