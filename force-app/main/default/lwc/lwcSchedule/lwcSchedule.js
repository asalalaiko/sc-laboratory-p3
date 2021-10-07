import { LightningElement, api, track, wire } from 'lwc';

import runBatch from'@salesforce/apex/SchedulableDetail.runBatch';
import getCRON from '@salesforce/apex/SchedulableDetailLWC.getCRON';
import getStateCronTrigger from'@salesforce/apex/SchedulableDetailLWC.getStateCronTrigger';
import isWorkedTrigger from '@salesforce/apex/SchedulableDetailLWC.isWorkedTrigger';
import stopSchedulable from'@salesforce/apex/SchedulableDetailLWC.stopSchedulable';
import tets2 from'@salesforce/apex/SchedulableDetailLWC.tets2';
import infoBatch from'@salesforce/apex/SchedulableDetailLWC.infoBatch';


export default class LwcSchedule extends LightningElement {
    @api BatchName;
    @api ScheduleName;

    @track valueCRON;
    @track State;
    @track isWork;
    @track valueCRON1;
    @track BatchBody;

    @wire(getCRON, {NameCronJobDetail: "$ScheduleName"})valueCRON;
    @wire(isWorkedTrigger, {NameCronJobDetail: "$ScheduleName"})isWork;    
    @wire(infoBatch, {BatchName: "$BatchName"}) BatchBody;

  
    onBatch(){
            runBatch({ apexClass: this.BatchName});
           
    }

    onSchedulable(){
          tets2({NameCronJobDetail: this.ScheduleName, CRONstr:this.valueCRON.data});
          window.location.reload();
        }
   
    offSchedulable(){
        stopSchedulable({NameCronJobDetail: this.ScheduleName});
        window.location.reload();
    }  
    
    infBatch(){
      alert(this.BatchBody.data);
    }

    changevalueCRON(event){
    this.valueCRON.data = event.target.value;
    }
        
  }