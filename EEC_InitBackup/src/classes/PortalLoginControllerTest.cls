/**
 * An apex page controller that exposes the site login functionality
 */
@IsTest global with sharing class PortalLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testPortalLoginController() {
       PortalLoginController controller = new PortalLoginController();
       controller.username = 'abcd';
       controller.password = '1234';
       controller.login();
       controller.forget();
       System.assertEquals(null, controller.login());       
       PortalLoginController controller2 = new PortalLoginController();
       controller2.username = '';
       controller2.login();
       
    }    
}