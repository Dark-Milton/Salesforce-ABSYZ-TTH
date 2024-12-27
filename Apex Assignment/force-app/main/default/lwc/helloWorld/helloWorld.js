import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    name = 'Sumanth'
    isShowing = false

    toggleChange(e) {
        this.isShowing = !this.isShowing
    }
}