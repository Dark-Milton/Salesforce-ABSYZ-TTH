import { api, LightningElement } from 'lwc';

export default class AccRecPicker extends LightningElement {
    @api objectApiName
    filter = {
        criteria: [
            {
                fieldPath: 'Fax',
                operator: 'ne',
                value: null,
            },
        ],
        filterLogic: '1',
    };
}