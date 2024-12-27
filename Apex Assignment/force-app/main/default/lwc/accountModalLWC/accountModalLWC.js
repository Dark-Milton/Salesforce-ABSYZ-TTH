import { LightningElement, wire } from 'lwc';
import AccountModal from 'c/accountModal'
import getAccountsWithLimit from '@salesforce/apex/AccountLWCController.getAccountsWithLimit'

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    {
        type: "button", label: 'View', initialWidth: 100, typeAttributes: {
            label: 'View',
            name: 'View',
            title: 'View',
            disabled: false,
            value: 'view',
            iconPosition: 'left',
            iconName:'utility:preview',
            variant:'Brand'
        }
    },
];
export default class AccountModalLWC extends LightningElement {
    columnsList = columns
    @wire(getAccountsWithLimit, {limitNo: '10'})
    accountList

    async handleRowAction(event) {
        const rowRecordId = event.detail.row.Id
        const result = await AccountModal.open({
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            accRecordId: rowRecordId,
        });
    }
}