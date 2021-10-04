import { LightningElement, api, wire, track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


import OPP_CONTACT_ID_FIELD from '@salesforce/schema/Opportunity.ContactId';
import CONTACT_ID_FIELD from '@salesforce/schema/Contact.Id';
import CONTACT_EMAIL_FIELD from  '@salesforce/schema/Contact.Email';

import GetEmail from'@salesforce/apex/GetEmailTemplate.GetEmail';
import GetContactRoles from'@salesforce/apex/GetEmailTemplate.GetContactRoles';
import GetContentDocumentId from'@salesforce/apex/GetEmailTemplate.getContentDocumentId';
import sendEmail from '@salesforce/apex/GetEmailTemplate.sendEmail';



export default class SendInvoceWebComponent extends NavigationMixin(LightningElement) {

    @api recordId;

    @track gCDI;
    @track email;


  
    @wire (GetEmail, {oppId: '$recordId'}) email;
  
    @wire (GetContentDocumentId, {oppId: '$recordId'}) gCDI;

    viewPdf() {
      
       this[NavigationMixin.Navigate]({
         type: 'standard__namedPage',
         attributes: {
             pageName: 'filePreview'
         },
         state : {
             recordIds: this.gCDI.data 
         }
       });
     }


  send() {
 
    const recordInput = {toSend: this.email.data.emailEmail, oppId: this.recordId, oppCD: this.gCDI.data}    //You can send parameters
    sendEmail(recordInput)
    .then( () => {
        console.log('Email send');//If response is ok
    }).catch( error => {
        console.log('Email NOT send !!!'+this.recordId);//If there is an error on response
    })

  }
   
   
   
   
   
   
   
   
   

}