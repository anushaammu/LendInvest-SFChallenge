public class TwilioSendSMSAPI {
    
    public static void SendNotification(List<Account> accountList){
        List<Id> accountIds = new List<Id>();
        for(Account a: accountList){
            if(a.Customer_Classification__c=='Gold' && a.Is_Gold__c==true){
                accountIds.add(a.Id);
            }
        }
        if(accountIds.size()>0)
        	sendMessageNotificationToGoldPartners(accountIds,'null','null');
        
    }
    @future(callout=true)
    public static void sendMessageNotificationToGoldPartners(List<Id> accountIds,String msg,String phone){
        //Variable Declarations
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        
    	//Query to get the Related Accounts Information
        List<Account> accountList = [select Id, Customer_Classification__c,Total_Customer_Spend__c,Phone,Name from Account where Id IN:accountIds];
        
        //Retrive the custom settings default values to build the REST API.
        Twilio__c twilio = Twilio__c.getInstance();
        //building the REST API endpoint.
        String endpoint = twilio.TwilioURL__c+twilio.Account_SID__c+'/SMS/Messages.json';
        
        //Creating a blob with AccountSId & Token
        Blob credentials = Blob.valueOf(twilio.Account_SID__c+':' + twilio.Token__c);
        
        req.setEndpoint(endPoint);
        req.setMethod('POST');//Using a Post method to send a Message Notification to the Customer
        
        //Preparing the Heders to Send REST callout to Twilio.
        req.setHeader('X-Twilio-Client', 'salesforce-' + twilio.Version__c);
        req.setHeader('User-Agent', 'twilio-salesforce/' + twilio.Version__c);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Accept-Charset', 'utf-8');
        req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(credentials));
        
        for(Account a:accountList){
            if(a.Customer_Classification__c=='Gold' && a.Phone !=null){
                //Custom message notification like Your Account has been upgraded for the Opportunity Closed-Won
                String.format(System.Label.SMSNotification,  new List<Object>{ a.Name });
                
                //Preparing the REST API body and Provided the Phone Numbers. Here, By default I have provided the Phone Number from the Twilio Account. 
                //'+19302054108' this Number I purchanged in Twilio to Send All My Message notifications to the customer.
                if(phone!=null)
                	req.setBody('To=' + EncodingUtil.urlEncode(phone, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(twilio.Phone_Number__c,'UTF-8') + '&Body=' + msg);
                else
                	req.setBody('To=' + EncodingUtil.urlEncode(a.Phone, 'UTF-8') + '&From=' + EncodingUtil.urlEncode(twilio.Phone_Number__c,'UTF-8') + '&Body=' + msg);
               
                system.debug(req);
                res = http.send(req);
            }
        }
        System.debug(res.getBody());

    }

}