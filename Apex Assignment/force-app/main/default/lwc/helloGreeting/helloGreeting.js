import { LightningElement } from 'lwc';

export default class HelloGreeting extends LightningElement {
    greeting = 'Sumanth'
    colorName;
    emoji = '✌🚀';

    get options() {
        return [
            { label: 'Red', value: 'Red' },
            { label: 'Green', value: 'Green' },
            { label: 'Blue', value: 'Blue' },
            { label: 'Yellow', value: 'Yellow' },
            { label: 'Black', value: 'Black' },
        ];
    }

    handleChange(event) {
        this.colorName = event.detail.value;
    }
}