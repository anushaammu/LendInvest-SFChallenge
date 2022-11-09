import { LightningElement, api } from 'lwc';
import sendSMS from '@salesforce/apex/SendSMSToGoldCustomerController.sendMessage';
import phoneNumber from '@salesforce/apex/SendSMSToGoldCustomerController.populatePhone';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';


export default class CustomMessageToCustomers extends LightningElement {
    @api recordId;
    @api getMessagefromCMP; 
    @api phone;
    
    connectedCallback(){
        phoneNumber({
            Id: this.recordId
        }).then(result=>{
            this.phone = result;
        })
    }
    handlephone(event){
        this.phone=event.detail.value;
    }

   handleMessage(event){
        this.getMessagefromCMP = event.detail.value;
   }
   
   handlesuccess(event) {
       console.log('phone::'+event);
       sendSMS({
           Id : this.recordId,
           message : this.getMessagefromCMP,
           phone:this.phone
       }).then(result => {
        const toastevent = new ShowToastEvent({
            title:result,
            message: "Successfully Sent Message to Customer",
            varient: "success"
        });
        this.dispatchEvent(toastevent);
       })
    
    }
    hanlderefresh(event){
        console.log(event);
        eval("$A.get('e.force:refreshView').fire();");
    }
}