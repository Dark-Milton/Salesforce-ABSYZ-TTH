import { api, LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
  } from "lightning/messageService";
import MyLMSMessageChannel from "@salesforce/messageChannel/myLMS__c";

const FIELDS = ["Contact.Name", "Contact.Title", "Contact.Phone", "Contact.Email"];

export default class ContactRecordViewForm extends LightningElement {
    @api recordId
    @api objectApiName
    subscription = null;
    contactData

    
    @wire(MessageContext)
    messageContext;

    @wire(getRecord, {recordId: "$recordId", fields: FIELDS})
    returnedContact
    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
        this.subscription = subscribe(
            this.messageContext,
            MyLMSMessageChannel,
            (message) => this.handleMessage(message),
            { scope: APPLICATION_SCOPE },
        );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    // Handler for message received by component
    handleMessage(message) {
        this.contactData = message.contactData;
        const event = new ShowToastEvent({
            title: 'Contact Modified',
            message:
                'Contact ' + this.contactData.firstName + ' is modified.',
        });
        this.dispatchEvent(event);
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}