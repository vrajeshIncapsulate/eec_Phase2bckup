/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest public with sharing class ForgotPageControllerTest {
     @IsTest(SeeAllData=true) public static void testForgotPageController() {
      // Instantiate a new controller with all parameters in the page
      ForgotPageController controller = new ForgotPageController();
      controller.username = 'test@salesforce.com';    
      //PageReference pr = Page.PortalLoginPage;   
      System.assert(controller.returnlogin().getUrl().toLowerCase().contains('portalloginpage')); 
      System.assertEquals(controller.forgotPassword(),null); 
      
    }
}