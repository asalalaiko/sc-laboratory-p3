import { LightningElement, api, wire, track} from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import searchAcc from'@salesforce/apex/getOppInfo.searchAcc';
import getAcc from'@salesforce/apex/getOppInfo.getAcc';
import GetProd from'@salesforce/apex/getOppInfo.getProd';
import GetTotalRecords from'@salesforce/apex/getOppInfo.getTotalRecords';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";


import NAME_FIELD from "@salesforce/schema/Account.Name";
const FIELDS = [NAME_FIELD];
const columns = [
    { label: 'Opportunity Name', fieldName: 'url', type: 'url', typeAttributes:{label: { fieldName: 'name' }}  },
    { label: 'Create Date', fieldName: 'createddate', type: 'date' },
    { label: 'Close Date', fieldName: 'closedate', type: 'date' },
    { label: 'Amount', fieldName: 'amount', type: 'currency' },
    { label: 'Product', fieldName: 'openModal', type: "button",  fixedWidth: 150,   
              typeAttributes: {label: 'View Details', title: 'View Details',  name: 'openModal',  variant: 'brand'},
    cellAttributes: {
        style: 'transform: scale(0.75)'
    } },
];

export default class OppAccountInfo extends  NavigationMixin(LightningElement)   {
  data = [];
  columns = columns;

  @api objectApiName;
  @api recordId;
 
  
  @track Accs;
  @track Acc;
  @track Prods;
  @track showModal = false;
  @track productId = '';
  @track pageSize = 10;
  @track pageNumber = 1;
  @track totalRecords = 0;
  @track totalPages = 0;
  @track recordEnd = 0;
  @track recordStart = 0;
  @track isPrev = true;
  @track isNext = false;

 
  renderedCallback(){
    
  if (this.totalRecords.data)  this.getAccounts();
  
}
  

 @wire(searchAcc, {accountName: '$searchAcc', searchSum:'$searchSum', pageSize: '$pageSize', pageNumber: '$pageNumber'}) Accs;
 @wire(getAcc, {idAcc:"$recordId"}) Acc;
 @wire(GetProd, {id: '$productId'}) Prods;
 @wire(getRecord, {recordId: "$recordId", fields: FIELDS}) account;
                  get name() {
                  return this.account.data.fields.Name.value;
                  }
 @wire(GetTotalRecords, {accountName: '$searchAcc', searchSum:'$searchSum'}) totalRecords;
 
 searchAcc = '';
 searchSum = 999999.99;
 


getAccounts(){
  
  
 this.recordStart = (this.pageNumber - 1) * this.pageSize+1;
 if (this.totalRecords.data <= this.pageNumber*this.pageSize)    
    {this.recordEnd =this.totalRecords.data  } 
  else 
    {this.recordEnd = this.pageNumber*this.pageSize;}
 
 this.totalPages = Math.ceil(this.totalRecords.data / this.pageSize);

 this.isNext = (this.pageNumber == this.totalPages || this.totalPages == 0);
 this.isPrev = (this.pageNumber == 1 || this.totalRecords.data < this.pageSize);
 
}

 

  //handle next
    handleNext(){
        this.pageNumber = this.pageNumber+1;
        this.getAccounts();
    }
 
    //handle prev
    handlePrev(){
        this.pageNumber = this.pageNumber-1;
        this.getAccounts();
    }
 

  changeHandlerAcc(event) {
    this.searchAcc = event.target.value;
    this.getAccounts();
  }
  changeHandlerSum(event) {
    this.searchSum = event.target.value;
    this.getAccounts();
  }

  get showSearch(){
    if(this.objectApiName == null){
            return true;} 
    else {
        return false;
  }
  }


  openModal(event) {
      // Setting boolean variable to true, this will show the Modal
      this.showModal = true;
     this.productId = event.detail.row.oppId;
  }

  closeModal() {
      // Setting boolean variable to false, this will hide the Modal
      this.showModal = false;
      this.productId = '';
  }
  
  
 


}