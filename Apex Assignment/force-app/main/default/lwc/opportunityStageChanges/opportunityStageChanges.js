import { api, LightningElement, wire } from 'lwc';
export default class OpportunityStageChanges extends LightningElement {
    message = '';
    current = '0'
    nextStep() {
        this.current = (parseInt(this.current) + 1) % 4;
        this.current = this.current.toString();
        this.showcomp1 = this.current === '0';
        this.showcomp2 = this.current === '1';
    }
    showcomp1 = true;
    showcomp2 = false;
    handleInputChange = (event) => {
        this.message = event.detail.value;
    }
}