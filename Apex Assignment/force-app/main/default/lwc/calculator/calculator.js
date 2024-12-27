import { LightningElement, track } from 'lwc';

export default class Calculator extends LightningElement {
    objInstance = {
        num1:0,
        num2:0,
        op:'+',
        res:0
    }
    @track results=[]
    handleChange = (event) => {
        const fieldName = event.target.name;
        const fieldValue = event.detail.value;

        this.objInstance[fieldName] = fieldValue
    }
    handleOperate = (event) => {
        try{
            const obj = {...this.objInstance}
            obj.op = event.target.symbol
            obj.res = eval(obj.num1+obj.op+obj.num2)
            this.results.push(obj)
        }
        catch(err) {
            console.log(JSON.stringify(err))
        }
    }

    isChecked = true
    checkBoxLabel = 'Checkbox is checked'
    handleChecked = () => {
        this.isChecked = !this.isChecked
        this.checkBoxLabel = this.isChecked ? 'Checkbox is checked': 'Checkbox is not checked'
    }
}