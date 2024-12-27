import { LightningElement, wire } from 'lwc';

import MyLMSMessageChannel from "@salesforce/messageChannel/myLMS__c";
import { publish,subscribe,unsubscribe,createMessageContext,releaseMessageContext, MessageContext } from 'lightning/messageService';


export default class ContactEditForm extends LightningElement {
    firstName;
    lastName;
    dateOfBirth;
    email;
    phone;
    accountName;
    isSaved=false;

    
    @wire(MessageContext)
    messageContext;

    onSave = () => {
        this.firstName = this.refs.firstName.value
        this.lastName = this.refs.lastName.value
        this.dateOfBirth = this.refs.dateOfBirth.value
        this.email = this.refs.email.value
        this.phone = this.refs.phone.value
        this.accountName = this.refs.accountName.value
        this.isSaved = true

        const contactData = {
            firstName: this.firstName,
            lastName: this.lastName,
            dateOfBirth: this.dateOfBirth,
            email: this.email,
            phone: this.phone,
            accountName: this.accountName,
        }
        const payload = { contactData: contactData };

        publish(this.messageContext, MyLMSMessageChannel, payload);
        console.log("Success")
    }
    onEdit = () => {
        this.isSaved = false
    }
    onCancel = ()=> {
        this.isSaved = true
    }

    callChildMethod = () => {
        console.log("Child calling...")
        this.refs.editFormChild.callFromParent();
        // this.template.querySelector("c-contact-edit-form-child").callFromParent();
    }
}