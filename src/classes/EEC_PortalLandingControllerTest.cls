@IsTest 
global with sharing class EEC_PortalLandingControllerTest {
    @IsTest(SeeAllData=false)     
     static void testEEC_PortalLandingController () {
       City__c city;  
       //User u;
       Account accnt;
       Contact con;
       User thisUser = [Select Id From User Where Id = :UserInfo.getUserId()];
       
         
       System.runAs(thisUser) {
         city = EEC_TestUtil.mockCity();
         RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
         accnt = EEC_TestUtil.mockProvider(city);
         con = EEC_TestUtil.mockDirectorContact(accnt);
       }
       
       //Account accnt = [select id from Account where RecordtypeID = :r.Id limit 1];  
       //Contact con = [select id from Contact where AccountId = :accnt.id limit 1 ];
       //EEC_TestUtil.mockDirectorContact(accnt);  
       System.debug('Accnt id ' + accnt.id);
       System.debug('Contact id '+ con.id);
       
       //ApexPages.currentPage().getParameters().put('accountid',accnt.id);    
       
      Account acc = [Select RecordType.Name From Account Where Id = :accnt.Id];
      
       Test.startTest();
       User u = EEC_PortalLandingControllerTest.mockuser(con);
       Lead_Configuration__c config = new Lead_Configuration__c(
         Name = acc.RecordType.Name,
         No_of_Days_For_Investigation_Due_Date__c = 1,
         Number_of_Non_Comp_before_longer_visit__c = 1,
         Portal_Home_Useful_Links__c = 'Links go here',
         Portal_Home_Welcome__c = 'Welcome to the testing home page.',
         Portal_Home_Latest_News__c = 'No news for testers!'  
       );  
       insert config;
       
     system.runas(u){
         EEC_PortalLandingController p1 = new EEC_PortalLandingController();
         p1.actionMethod();
         p1.gotoPersonalPage();
         p1.goToProviderPage();
         p1.goToUmbrellaPage();
         p1.goToSubmitNewTransaction();
         p1.noncomp();
         p1.investigationPage();
         p1.goToSubmitNewIncident();
         System.assertNotEquals(null, p1.getLeadConfiguration());
         System.assertNotEquals(null, p1.getAccount());
         
         PageReference restraintPage = Page.EEC_RestraintReport; 
         restraintPage.getParameters().put('accountId', accnt.Id);
         
         //System.assertEquals(restraintPage.getUrl(), p1.goToSubmitNewRestraint().getUrl());
      }
       
       //System.assertEquals(null, p1.actionMethod());       
    }  
    
    public static User mockUser(Contact cont){
    User u;     
    //City__c city = EEC_TestUtil.mockCity();
    //Account a = EEC_TestUtil.mockProvider(city);
    
    //Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id, Role__c = 'Main Contact / Licensee');
    //insert c;    
    
    Profile p = [SELECT ID,Name FROM Profile where name = 'Community Standard User without transactions for EEC' LIMIT 1];
    //UserRole roleId = [Select Id,PortalType, PortalAccountId From UserRole where PortalType ='CustomerPortal' limit 1];  
    //System.debug('-----> UserRole ID: ' + roleId);
    u = new User(
            Email = 'test@test.com',
            LastName =  EEC_TestUtil.generateRandomString(5),
            FirstName = EEC_TestUtil.generateRandomString(5),
            Username =  EEC_TestUtil.generateRandomString(26) + '@test.com',
            Alias = EEC_TestUtil.generateRandomString(5),
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileID = p.Id,
            //PortalRole = 'Worker',
        	//UserRoleID = roleId.Id,
            ContactId = cont.Id,
        	IsActive = true,
        	CommunityNickname = 'testUser123',
            LanguageLocaleKey = 'en_US'
        );
       insert u;
       return u;
    }
}