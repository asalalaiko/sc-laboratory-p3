import { LightningElement, api, track, wire } from 'lwc';

import runBatch from'@salesforce/apex/SchedulableDetail.runBatch';
import getCRON from '@salesforce/apex/SchedulableDetailLWC.getCRON';
import getStateCronTrigger from'@salesforce/apex/SchedulableDetailLWC.getStateCronTrigger';
import isWorkedTrigger from '@salesforce/apex/SchedulableDetailLWC.isWorkedTrigger';
import stopSchedulable from'@salesforce/apex/SchedulableDetailLWC.stopSchedulable';
import tets2 from'@salesforce/apex/SchedulableDetailLWC.tets2';


export default class LwcSchedule extends LightningElement {
    @api BatchName;
    @api ScheduleName;

    valueCRON ='';
    @track State;
    @track isWork;

    @wire(getCRON, {NameCronJobDetail: "$ScheduleName"})valueCRON;
    @wire(isWorkedTrigger, {NameCronJobDetail: "$ScheduleName"})isWork;    

  
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

    changevalueCRON(event){
    this.valueCRON.data = event.target.value;
    }
        
  }