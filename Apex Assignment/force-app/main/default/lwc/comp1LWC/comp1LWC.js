import { LightningElement, wire } from 'lwc';
import componentChannel from "@salesforce/messageChannel/compLMS__c";
import { publish, MessageContext } from "lightning/messageService";

export default class Comp1LWC extends LightningElement {
    comp1Data=''
    handleChange(event) {
        this.comp1Data=event.detail.value
        const payload = { comp1Data: this.comp1Data };
        publish(this.messageContext, componentChannel, payload);
    }

    @wire(MessageContext)
    messageContext;


    comp1DataTask17=''
    handleChangeTask17(event) {
        this.comp1DataTask17=event.detail.value
    }
    handleClick(event) {
        const payload = { comp1DataTask17: this.comp1DataTask17 };
        publish(this.messageContext, componentChannel, payload);
    }
}