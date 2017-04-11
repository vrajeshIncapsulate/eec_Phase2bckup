@isTest
public class EEC_NavBarControllerTest {

  static testMethod void testGetAcc() {
    // Create mock account and user in the system.  
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_PortalLandingControllerTest.mockuser(con);
      
    System.runAs(u) {      
      Test.startTest();
      // Get instance of controller.
      EEC_NavBarController ctrl = new EEC_NavBarController();
      Account controllerAccount = ctrl.getAcc();
      // Test that account is available.
      System.assertEquals(acc.Name, controllerAccount.Name);      
    }
  }
    
  static testMethod void testGetLicensorEmail() {
    // Create mock account and user in the system.  
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact con = EEC_TestUtil.mockDirectorContact(acc);
    User u = EEC_PortalLandingControllerTest.mockuser(con);
      
    System.runAs(u) {      
      Test.startTest();
      // Get instance of controller.
      EEC_NavBarController ctrl = new EEC_NavBarController();
      String email = ctrl.getLicensorEmail();
      // Test that account is available.
      System.assertEquals(null, email);    
      ctrl.acc = acc;
      email = ctrl.getLicensorEmail();
      System.assertEquals('', email);        
    }     
  }
}