import { LightningElement, wire } from 'lwc';
import makeGetCallout from '@salesforce/apex/ApexCallout.makeGetCallout'

export default class AnimalCalloutLWC extends LightningElement {
    animalData

    handleClick(event) {
        makeGetCallout()
        .then(data => {
            console.log(JSON.stringify(data))
            this.animalData=data
        })
        .catch(err => {
            console.log(JSON.stringify(error))
        })
    }
}