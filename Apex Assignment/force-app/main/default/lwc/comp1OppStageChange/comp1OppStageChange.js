import { LightningElement } from 'lwc';

export default class Comp1OppStageChange extends LightningElement {
    message = '';
    handleChange = (event) => {
        this.message = event.detail.value;
        let eve = new CustomEvent('inputchange', {
            detail: {
                value: this.message
            }
        });
        this.dispatchEvent(eve);
    }
}