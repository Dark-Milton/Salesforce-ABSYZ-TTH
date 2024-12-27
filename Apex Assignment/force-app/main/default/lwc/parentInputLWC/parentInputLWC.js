import { LightningElement } from 'lwc';

export default class ParentInputLWC extends LightningElement {
    parentData=''
    childData=''
    handleChange(event) {
        this.parentData=event.detail.value
    }
    handleChildData = (event) => {
        this.childData = event.detail
    }
    handleClick(event) {
        this.template.querySelector('c-child-input-l-w-c').alertFromChild("Hii, User")
    }
}