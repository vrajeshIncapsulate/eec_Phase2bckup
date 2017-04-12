@isTest	
public class CustomLoginControllerTest {
    static testMethod void testForwardToCustomAuthPage() {
      CustomLoginController ctrl = new CustomLoginController();
      System.assertEquals('/CustomLogin', ctrl.forwardToCustomAuthPage().getUrl());
    }
    
    static testMethod void testLogin() {
      // Setup user.
      Contact cont = EEC_TestUtil.mockContact();
      Profile p = [SELECT ID FROM Profile where name = 'Customer Community User' LIMIT 1];  
      UserRole userR = [Select Id From UserRole LIMIT 1];
      User u = new User(
          Email = 'test@test.com',
          LastName =  EEC_TestUtil.generateRandomString(5),
          FirstName = EEC_TestUtil.generateRandomString(5),
          Username =  EEC_TestUtil.generateRandomString(26) + '@test.com',
          Alias = EEC_TestUtil.generateRandomString(5),
          TimeZoneSidKey = 'GMT',
          LocaleSidKey = 'en_US',
          EmailEncodingKey = 'ISO-8859-1',
          ProfileID = p.Id,
          UserRoleID = userR.Id,
          ContactId = cont.Id,
          LanguageLocaleKey = 'en_US'
      );
      Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
      Site.createPortalUser(u, acc.Id, 'password');  
        
      CustomLoginController ctrl = new CustomLoginController();
      ctrl.username = u.Username;
      ctrl.password = 'password';
      PageReference ref = ctrl.login();
      System.debug('----> ref: ' + ref); 
    }
}