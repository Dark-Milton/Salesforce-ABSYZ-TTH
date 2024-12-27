import { LightningElement, wire } from 'lwc';
import {
  subscribe,
  unsubscribe,
  APPLICATION_SCOPE,
  MessageContext,
} from "lightning/messageService";
import componentChannel from "@salesforce/messageChannel/compLMS__c";

export default class Comp2LWC extends LightningElement {
    comp1Data=''
    comp1DataTask17=''
    @wire(MessageContext)
    messageContext;

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
            this.messageContext,
            componentChannel,
            (message) => this.handleMessage(message),
            { scope: APPLICATION_SCOPE },
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleMessage(message) {
        this.comp1Data = message.comp1Data ? message.comp1Data : this.comp1Data
        this.comp1DataTask17 = message.comp1DataTask17 ? message.comp1DataTask17 : this.comp1DataTask17
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}