@IsTest 
global with sharing class EEC_MyProfileControllerTest {
   @IsTest(SeeAllData=false)     
   global static void testEEC_MyProfileController() {
     //RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
     Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
     Contact con = EEC_TestUtil.mockDirectorContact(accnt);
     //Account accnt = [select id from Account where RecordtypeID = :r.Id limit 1];  
     //Contact con = [select id from Contact where AccountId = :accnt.id limit 1 ];
     //EEC_TestUtil.mockDirectorContact(accnt);  
     //ApexPages.currentPage().getParameters().put('accountid',accnt.id);    
      
     User u = EEC_PortalLandingControllerTest.mockuser(con);
         
     system.runas(u){
       EEC_MyProfileController p1 = new EEC_MyProfileController();
       //p1.refreshUser();
       p1.save();
       p1.getStates();
         
       con = [Select Id, Salutation, Title, FirstName, LastName, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode, Phone From Contact Where Id = :con.Id];
         
       UserUtil.updateUserContact(
           u.Id, con.Salutation, con.Title, con.FirstName, con.LastName, 
           con.MailingStreet, con.MailingCity, con.MailingState, con.MailingCountry, con.MailingPostalCode,
           con.Phone, null, u.Email);
     }
   }
}