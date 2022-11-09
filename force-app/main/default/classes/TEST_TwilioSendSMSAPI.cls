@IsTest
public class TEST_TwilioSendSMSAPI {
    
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
        
        Opportunity opp = new Opportunity(AccountId=acc.Id,Name='Test Opp1',CloseDate=Date.Today(),StageName='Prospecting', Amount=500000.0);
        Opportunity opp1 = new Opportunity(AccountId=acc.Id,Name='Test Opp2',CloseDate=Date.Today(),StageName='Prospecting', Amount=500000.0);
        
        Opportunity opp2 = new Opportunity(AccountId=acc1.Id,Name='Test Opp1',CloseDate=Date.Today(),StageName='Prospecting', Amount=30000.0);
        Opportunity opp3 = new Opportunity(AccountId=acc1.Id,Name='Test Opp2',CloseDate=Date.Today(),StageName='Prospecting', Amount=30000.0);
        
        oppListToInsert.add(opp);
        oppListToInsert.add(opp1);
        oppListToInsert.add(opp2);
        oppListToInsert.add(opp3);
        
        insert oppListToInsert;
    }
    
	@isTest
    public Static void TestSendSMSToGoldCustomerUpdate(){
        Account acc = [select id,Is_Gold__c,Customer_Classification__c,Total_Customer_Spend__c,Phone,Name from Account where AccountNumber='123435' limit 1];
        
        List<Opportunity> opp = [select id,AccountId,Name,CloseDate,StageName,Amount from Opportunity where AccountId=:acc.Id];
        for(Opportunity o: opp){
        	o.StageName='Closed Won';
        }
        update opp;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        opp[0].Amount=2000;
        update opp[0];
        Account acc2 = [Select id,Is_Gold__c,Customer_Classification__c,Total_Customer_Spend__c from Account where id=:acc.Id];
        
        System.assertEquals(True,acc2.Is_Gold__c);
        
        Test.stopTest();
    }
    
    @isTest
    public Static void SendSMSToGoldCustomerControllerTest(){
        Account acc = [select id,Is_Gold__c,Customer_Classification__c,Total_Customer_Spend__c,Phone,Name from Account where AccountNumber='123435' limit 1];
        
        List<Opportunity> opp = [select id,AccountId,Name,CloseDate,StageName,Amount from Opportunity where AccountId=:acc.Id];
        for(Opportunity o: opp){
        	o.StageName='Closed Won';
        }
        update opp;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc1 = [Select id,Is_Gold__c,Customer_Classification__c,Total_Customer_Spend__c from Account where id=:acc.Id];
        
        System.assertEquals(True,acc1.Is_Gold__c);
        System.assertEquals('Gold',acc1.Customer_Classification__c);
        
        Test.stopTest();
    }
    
    @isTest
    public Static void SendSMSToGoldCustomerControllerTest1(){
        Account acc = [select id,Is_Gold__c,Customer_Classification__c,Total_Customer_Spend__c,Phone,Name from Account where AccountNumber='123987' limit 1];
        
        List<Opportunity> opp = [select id,AccountId,Name,CloseDate,StageName,Amount from Opportunity where AccountId=:acc.Id];
        for(Opportunity o: opp){
        	o.StageName='Closed Won';
        }
        update opp;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Account acc1 = [Select id,Is_Gold__c,Customer_Classification__c,Total_Customer_Spend__c from Account where id=:acc.Id];
        
        System.assertNotEquals(True,acc1.Is_Gold__c);
        System.assertNotEquals('Gold',acc1.Customer_Classification__c);
        Test.stopTest();
    }

}