public with sharing class SendSMSToGoldCustomerController {
    @AuraEnabled
    public static String sendMessage(String Id, String message,String phone){
        string message1;
        try{
            List<Id> accountId = new List<Id>();
            if(Id!=null && message!=null && phone!=null){
                accountId.add(Id);
                System.debug('AccountID::'+accountId+'  Message::'+message+'  Phone::'+phone);
                TwilioSendSMSAPI.sendMessageNotificationToGoldPartners(accountId,message,phone);
                message1='success';
            }
        } catch (Exception e) {
            message1 ='failed';
        }
        return message1;
    }
}