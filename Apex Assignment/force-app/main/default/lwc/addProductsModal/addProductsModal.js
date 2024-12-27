import { api, LightningElement, track, wire } from 'lwc';
import getAllProducts from '@salesforce/apex/AccountProductLWCController.getAllProducts';
import getProductsByAccountId from '@salesforce/apex/AccountProductLWCController.getProductsByAccountId';
import createAccountProductsByAccountIdAndProductId from '@salesforce/apex/AccountProductLWCController.createAccountProductsByAccountIdAndProductId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from "@salesforce/apex";

const columns = [
    { label: 'Name', fieldName: 'Name', sortable: true },
    { label: 'Product Code', fieldName: 'ProductCode', sortable: true }
]
export default class AddProductsModal extends LightningElement {

    //recordId Approach
    @api recordId;


    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    onHandleSort(event) {
        console.log('Event Details', JSON.stringify(event.detail));
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.filteredProducts];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.filteredProducts = cloneData;
        console.log('Filtered Products', this.filteredProducts);
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    @track products = [];
    @track filteredProducts = [];
    searchKey = '';

    // @track selectedData = [];
    @track selectedDataIds = [];
    @track selectedProducts = [];
    

    columnsList = columns;

    @wire(getProductsByAccountId, { accountId: '$recordId' })
    existingProducts

    @wire(getAllProducts)
    handleProducts({ data, error }) {
        if (data) {
            this.products = data.map(product => ({
                Id: product.Id,
                Name: product.Name,
                ProductCode: product.ProductCode
            }));
            this.filteredProducts = [...this.products];
        } else if (error) {
            console.error(error.message);
        }
    }

    handleSearch(event) {
        this.searchKey = event.target.value.toLowerCase();
        if (this.searchKey) {
            this.filteredProducts = this.products.filter(product =>
                product.ProductCode.toLowerCase().includes(this.searchKey)
            );
        } else {
            this.filteredProducts = [...this.products];
        }

        this.selectedDataIds = this.selectedDataIds.map(data => data);
        // this.selectedData = Array.from(this.selectedDataIds).filter(id =>
        //     this.filteredProducts.some(product => product.Id === id)
        // );
    }

    handleRowSelection(event) {
        // console.log('Event Details', JSON.stringify(event.detail));
        // const selectedRowsId = event.detail.selectedRows.map(row => row.Id);
        // selectedRowsId.forEach(id => this.selectedDataIds.add(id));

        // const deselectedRows = this.filteredProducts
        //     .filter(product => !selectedRowsId.includes(product.Id))
        //     .map(product => product.Id);
        // deselectedRows.forEach(id => this.selectedDataIds.delete(id));

        // this.selectedProducts = this.products.filter(product =>
        //     this.selectedDataIds.has(product.Id)
        // );

        // this.selectedData = Array.from(this.selectedDataIds).filter(id =>
        //     this.filteredProducts.some(product => product.Id === id)
        // );


        try{
            switch (event.detail.config.action) {
                case 'selectAllRows':
                    this.filteredProducts.map(product => this.selectedDataIds.push(product.Id));
                    break;
                case 'deselectAllRows':
                    this.filteredProducts.map(product => {
                        const index = this.selectedDataIds.indexOf(product.Id);
                        if (index > -1) {
                            this.selectedDataIds.splice(index, 1);
                        }
                    });
                    break;
                case 'rowSelect':
                    this.selectedDataIds.push(event.detail.config.value);
                    break;
                case 'rowDeselect':
                    const index = this.selectedDataIds.indexOf(event.detail.config.value);
                    if (index > -1) {
                        this.selectedDataIds.splice(index, 1);
                    }
                    break;
                default:
                    break;
            }
            this.selectedProducts = this.products.filter(product =>
                this.selectedDataIds.includes(product.Id)
            );
            console.log('Selected Data', this.selectedDataIds.length);
        }
        catch (error) {
            console.error(error.message);
        }
    }

    handleSave() {
        if (this.selectedProducts.length === 0) return;

        createAccountProductsByAccountIdAndProductId({ accountId: this.recordId, products: this.selectedProducts })
        .then(() => {
            const toastEvent = new ShowToastEvent({
                title: 'Products added successfully',
                variant: 'success'
            });
            this.dispatchEvent(toastEvent);
            this.selectedDataIds = [];
            this.selectedProducts = [];
            refreshApex(this.existingProducts);
        })
        .catch(error => {
            console.error(error);
            const toastEvent = new ShowToastEvent({
                title: 'Error adding products',
                message: error.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        });
    }

    //Row Index Approach
    // @api recordId
    // columnsList = columns

    // searchKey = ''
    // filteredProducts = []
    // handleSearch(event) {
    //     this.searchKey = event.target.value.toLowerCase();
    //     if (this.searchKey) {
    //         this.filteredProducts = this.products.filter(product =>
    //             product.ProductCode.toLowerCase().includes(this.searchKey)
    //         );
    //     } else {
    //         this.filteredProducts = [...this.products];
    //     }
    //     this.selectedData = this.selectedData.map(data => data)
    // }

    // products = []
    // @wire(getAllProducts)
    // handleProducts({ data, error }) {
    //     if(data) {
    //         let newProducts = []
    //         for(let i = 0; i < data.length; i++) {
    //             newProducts.push({
    //                 Id: data[i].Id,
    //                 Name: data[i].Name,
    //                 ProductCode: data[i].ProductCode,
    //                 keyField: 'row-'+i
    //             })
    //         }
    //         this.products = newProducts.map(product => {
    //             return {
    //                 Id: product.Id,
    //                 Name: product.Name,
    //                 ProductCode: product.ProductCode,
    //                 keyField: product.keyField
    //             }
    //         })
    //         this.filteredProducts = this.products.map(product => product)
    //     }
    //     else if(error) {
    //         console.error(error.message)
    //     }
    // }

    // @wire(getProductsByAccountId, { accountId: '$recordId' })
    // existingProducts

    // selectedData = []
    // selectedProducts = []
    // // currentlySelectedData = []

    // handleRowSelection(event) {
    //     try{

    //     switch (event.detail.config.action) {
    //         case 'selectAllRows':
    //             for (let i = 0; i < event.detail.selectedRows.length; i++) {
    //                 this.selectedData.push(event.detail.selectedRows[i].keyField);
    //             }
    //             break;
    //         case 'deselectAllRows':
    //             const deselectedRows = this.filteredProducts.map(product => product.keyField);
    //             this.selectedData = this.selectedData.filter(key => !deselectedRows.includes(key));
    //             break;
    //         case 'rowSelect':
    //             this.selectedData.push(event.detail.config.value);
    //             break;
    //         case 'rowDeselect':
    //             const index = this.selectedData.indexOf(event.detail.config.value);
    //             if (index !== -1) {
    //                 this.selectedData.splice(index, 1);
    //             }
    //             break;
    //         default:
    //             break;
    //     }
    //     this.selectedProducts = this.products.filter(product => {
    //         return this.selectedData.includes(product.keyField)
    //     })
        
    //     }
    //     catch (error) {
    //         console.error(error.message);
    //     }

    // }

    // handleSave() {
    //     if(this.selectedProducts.length === 0) return;
    //     createAccountProductsByAccountIdAndProductId({ accountId: this.recordId, products: this.selectedProducts })
    //     .then(() => {
    //         let toastEvent = new ShowToastEvent({
    //             title: 'Products added successfully',
    //             variant: 'success'
    //         });
    //         this.dispatchEvent(toastEvent);
    //         refreshApex(this.existingProducts);
    //     })
    //     .catch(error => {
    //         console.error(error)
    //         let toastEvent = new ShowToastEvent({
    //             title: 'Products creation failed',
    //             variant: 'error',
    //             message: error.message
    //         });
    //         this.dispatchEvent(toastEvent);
    //     })
    // }
}