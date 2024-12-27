import { LightningElement, wire } from 'lwc';
import getTollRecords from '@salesforce/apex/TollTransactionDashboardLWCController.getTollRecords';
import getTollRecordsWithFilter from '@salesforce/apex/TollTransactionDashboardLWCController.getTollRecordsWithFilter';
import Vehicle_Object from '@salesforce/schema/Vehicle__c';
import Vehicle_Type_Field from '@salesforce/schema/Vehicle__c.Vehicle_Type__c';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

import TollTransactionModal from 'c/tollTransactionModal'

const columns = [
    { label: 'Transaction ID', fieldName: 'Name', type: 'text' },
    { label: 'Vehicle', fieldName: 'VehicleName', type: 'text' },
    { label: 'Vehicle Type', fieldName: 'VehicleType', type: 'text' },
    { label: 'Plaza', fieldName: 'PlazaName', type: 'text' },
    { label: 'Transaction Date', fieldName: 'Transaction_Date__c', type: 'text' },
    { label: 'Amount Charged', fieldName: 'Amount_Charged__c', type: 'text' },
    {
        type: "button", label: 'Edit', initialWidth: 100, typeAttributes: {
            label: 'Edit',
            name: 'Edit',
            title: 'Edit',
            disabled: false,
            value: 'edit',
            iconPosition: 'left',
            iconName:'utility:edit',
            variant:'Brand'
        }
    },
];

export default class TollTransactionDashboard extends LightningElement {
    columns = columns;
    tollRecordList = []
    error
    startDate
    endDate
    vehicleType=''
    transactionAmount

    handleChange(event) {
        if(event.target.name === 'StartDate') {
            this.startDate=new Date(event.detail.value)
            console.log(this.startDate)
        }
        if(event.target.name === 'EndDate') {
            this.endDate=new Date(event.detail.value)
        }
        if(event.target.name === 'VehicleType') this.vehicleType=event.detail.value
        if(event.target.name === 'transactionAmount') this.transactionAmount=event.detail.value

        console.log(typeof this.transactionAmount)
    }

    async handleRowAction(event) {
        const rowRecordId = event.detail.row.Id
        try{
            const result = await TollTransactionModal.open({
                size: 'large',
                description: 'Accessible description of modal\'s purpose',
                tollRecordId: rowRecordId,
            });
        }
        catch(err) {
            console.log(err.message())
        }
    }

    async handleClick(event) {
        console.log('Hii')
        try {
            console.log('Hii')
            if(this.transactionAmount=='') this.transactionAmount = null
            console.log(this.transactionAmount)
            const tollRecordListRes = await getTollRecordsWithFilter({startDate: this.startDate, endDate: this.endDate, vehicleType: this.vehicleType, transactionAmount: this.transactionAmount});
            const modifiedList = tollRecordListRes.map((rec, i) => {
                return {...rec, VehicleName: rec.Vehicle__r.Name, PlazaName: rec.Plaza__r.Name, VehicleType: rec.Vehicle__r.Vehicle_Type__c}
            })
            console.log(modifiedList)
            this.tollRecordList = modifiedList
            this.error = undefined;
        } catch (error) {
            this.tollRecordList = undefined;
            this.error = error;
        }
    }
    

    @wire(getObjectInfo, { objectApiName: Vehicle_Object })
    vehicleInfo;
    @wire(getPicklistValues, { recordTypeId: '$vehicleInfo.data.defaultRecordTypeId', fieldApiName: Vehicle_Type_Field })
    vehicleTypesPicklistValues


    async handleLoadData() {
        try {
            const tollRecordListRes = await getTollRecords();
            const modifiedList = tollRecordListRes.map((rec, i) => {
                return {...rec, VehicleName: rec.Vehicle__r.Name, PlazaName: rec.Plaza__r.Name, VehicleType: rec.Vehicle__r.Vehicle_Type__c}
            })
            console.log(modifiedList)
            this.tollRecordList = modifiedList
            this.error = undefined;
        } catch (error) {
            this.tollRecordList = undefined;
            this.error = error;
        }
    }
    connectedCallback() {
        this.handleLoadData();
    }
}