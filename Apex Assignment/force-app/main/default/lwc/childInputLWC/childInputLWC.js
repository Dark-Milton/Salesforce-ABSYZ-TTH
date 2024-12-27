import { api, LightningElement } from 'lwc';

export default class ChildInputLWC extends LightningElement {
    @api parentData;
    childData=''
    handleChange(event) {
        this.childData = event.detail.value
        const ev = new CustomEvent('childdata', {detail: this.childData})
        this.dispatchEvent(ev)
    }

    @api alertFromChild(message) {
        alert(`This is function of Child LWC, message: ${message}`)
        // alert('This is function of Child LWC, message: ' + message)
    }
}