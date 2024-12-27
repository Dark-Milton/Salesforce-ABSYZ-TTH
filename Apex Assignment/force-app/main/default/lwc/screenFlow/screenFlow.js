import { LightningElement } from 'lwc';

export default class ScreenFlow extends LightningElement {
    outputVariables
    outputVariableValue

    get inputVariables() {
        return [
            {
                name: 'message',
                type: 'String',
                value: 'Hii from LWC'
            }
        ];
    }
    handleStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            alert("Flow is finished")
            this.outputVariables = event.detail.outputVariables
            console.log(this.outputVariables)
            this.outputVariableValue = this.outputVariables[0].name
        }
    }
}