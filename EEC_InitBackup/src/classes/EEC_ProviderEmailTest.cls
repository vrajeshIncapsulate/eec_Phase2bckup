@istest 
public with sharing class EEC_ProviderEmailTest {
	 
	 @istest static void EEC_ProviderContactEmail(){
	Account acc1 = new Account();          
          Date cDate =  System.today();  
          // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
          acc1.Name = 'Test account 1 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = EEC_TestUtil.mockCity().Id;
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Restraint_Method__c = 'OWN';
          acc1.Use_Physical_Restraints__c = true;
          acc1.Renewal_date__c = cdate +30; 
          acc1.Provider_No__c = '603735';
          insert acc1;
          
           Contact c = new Contact();
          c.FirstName = 'Test';
          c.LastName = 'Contact';
          c.AccountId = acc1.Id; 
          insert c; 
          
          User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
          
         Test.startTest();
     	string SOQL = 'Select Id,Name,email from contact';
     	EEC_ProviderEmailContactBatch Email = new EEC_ProviderEmailContactBatch();
     	Email.query=SOQL;
        Id t = Database.executeBatch(Email);  
        Test.stopTest();
	}
	@istest static void EEC_ProviderUserEmail(){
	
	Account acc1 = new Account();          
          Date cDate =  System.today();  
          // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
          acc1.Name = 'Test account 1 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = EEC_TestUtil.mockCity().Id;
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Restraint_Method__c = 'OWN';
          acc1.Use_Physical_Restraints__c = true;
          acc1.Renewal_date__c = cdate +30; 
          acc1.Provider_No__c = '603735';
          insert acc1;
          
           Contact c = new Contact();
          c.FirstName = 'Test';
          c.LastName = 'Contact';
          c.AccountId = acc1.Id; 
          insert c;
          
          User U = new user();
          
          
         Test.startTest();
     	string SOQL1 = 'Select Id,Name,email from user limit 1';
        EEC_ProviderEmailUserBatch UEmail = new EEC_ProviderEmailUserBatch();
        UEmail.query=SOQL1;
        Id id = Database.executeBatch(UEmail); 
        Test.stopTest();
	
	}
    
}