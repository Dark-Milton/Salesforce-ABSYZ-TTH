import { api, LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from "@salesforce/schema/Account.Name";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";
import RATING_FIELD from "@salesforce/schema/Account.Rating";


export default class AccountRecordDetail extends LightningElement {
    @api recordId
    fields = [NAME_FIELD, INDUSTRY_FIELD, RATING_FIELD]

    @track accountRecord={}
    @wire(getRecord, { recordId: '$recordId', fields: '$fields'})
    accountRecordFunc({data, error}) {
        if(data) {
            console.log(JSON.stringify(data))
            this.accountRecord.data = data
            console.log('feld data: ', this.accountRecord.data.fields.Name.value)
        }
        else if(error) {
            console.log(JSON.stringify(error))
            this.accountRecord.error = error
        }
    }
}