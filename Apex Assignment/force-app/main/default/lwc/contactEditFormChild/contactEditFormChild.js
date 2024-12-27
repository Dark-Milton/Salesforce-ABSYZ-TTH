import { api, LightningElement, track } from 'lwc';

export default class ContactEditFormChild extends LightningElement {
    @api firstName;
    @api lastName;
    @api dateOfBirth;
    @api email;
    @api phone;
    @api accountName;

    onEdit = (e) => {
        let ev = new CustomEvent('fieldedit');
        console.log(e)
        this.dispatchEvent(ev);
    }

    @api callFromParent() {
        console.log("Child Called")
        alert("Hii, Here's a sweet message from Child")
    }
}