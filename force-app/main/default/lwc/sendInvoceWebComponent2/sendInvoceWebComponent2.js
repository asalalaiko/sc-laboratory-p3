import { LightningElement, api } from 'lwc';

export default class SendInvoceWebComponent2 extends LightningElement {

    @api recordId;
    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
    }
}