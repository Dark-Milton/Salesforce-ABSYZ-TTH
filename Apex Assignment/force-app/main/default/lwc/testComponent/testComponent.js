import { LightningElement } from 'lwc';

export default class TestComponent extends LightningElement {
    handleClick() {
        alert('Hello World');
    }
    name = 'Sumanth';
}