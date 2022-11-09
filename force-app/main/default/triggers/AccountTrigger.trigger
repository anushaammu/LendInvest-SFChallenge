trigger AccountTrigger on Account (after update) {
    List<Account> accountList = new List<Account>();
    if(trigger.isAfter && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(Trigger.newMap.get(acc.Id).Is_Gold__c ==true && (Trigger.oldMap.get(acc.Id).Is_Gold__c !=acc.Is_Gold__c)){
                accountList.add(acc);
            }
        }
        if(accountList.size()>0){ 
        	TwilioSendSMSAPI.SendNotification(accountList);
        }
    }
}