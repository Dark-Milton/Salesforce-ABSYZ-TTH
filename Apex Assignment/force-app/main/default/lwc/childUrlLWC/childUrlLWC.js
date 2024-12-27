import { LightningElement } from 'lwc';

export default class ChildUrlLWC extends LightningElement {
    handleClick(event) {
        const ev = new CustomEvent('urlbuttonclick', {
            detail: {
                url: event.target.url
            }
        });
        this.dispatchEvent(ev)
    }
}