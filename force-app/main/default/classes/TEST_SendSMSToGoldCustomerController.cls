@IsTest
public class TEST_SendSMSToGoldCustomerController {
	@testsetup
    public static void loadData(){
        //Custom Setting test data
        Twilio__c twilio = new Twilio__c();
        twilio.Name='Test';
        twilio.Account_SID__c='35794835154';
        twilio.Phone_Number__c='+56982542345';
        twilio.Token__c='269340526';
        twilio.TwilioURL__c='https://abc.com';
        twilio.Version__c='3.2.0';
        insert twilio;
        
        List<Account> accListToInsert = new List<Account>();
        List<Opportunity> oppListToInsert = new List<Opportunity>();
        Account acc = new Account(AccountNumber='123435',Name='Test',Phone='+44 7776672865');
        
        Account acc1 = new Account(AccountNumber='123987',Name='Test1',Phone='51346890584');
    	accListToInsert.add(acc);
        accListToInsert.add(acc1);
        insert accListToInsert;

    }
    @isTest
    public Static void TestSendSMSToGoldCustomerUpdate1(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc= [select id,Phone from Account where AccountNumber='123435'];
        
        String msg = SendSMSToGoldCustomerController.sendMessage('12345','Testing','null');
        
        System.assertEquals('failed',msg);
        Test.StopTest();
        
    }
    
	@isTest
    public Static void TestSendSMSToGoldCustomerUpdate(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc= [select id,Phone from Account where AccountNumber='123435'];
        
        String msg = SendSMSToGoldCustomerController.sendMessage(acc.Id,'Testing',acc.Phone);
        System.assertEquals('success',msg);
        Test.StopTest();
        
    }
}