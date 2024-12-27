import { LightningElement } from 'lwc';

export default class ParentUrlLWC extends LightningElement {
    url=''
    handleURLButtonClick(event) {
        this.url = event.detail.url
    }
}