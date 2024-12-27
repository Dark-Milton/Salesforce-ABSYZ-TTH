import { api, wire } from 'lwc';
import LightningModal from 'lightning/modal';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from "@salesforce/schema/Account.Name";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";

export default class AccountModal extends LightningModal {
    @api accRecordId

    @wire(getRecord, { recordId: '$accRecordId', fields: [NAME_FIELD, INDUSTRY_FIELD]})
    accountData
    // accountDataFunc({data, error}) {
    //     if(data) {
    //         console.log(JSON.stringify(data))
    //         this.accountData = data
    //     }
    //     else if(error) {
    //         console.log(JSON.stringify(error))
    //     }
    // }
}