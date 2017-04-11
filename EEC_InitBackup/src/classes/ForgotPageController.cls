public with sharing class ForgotPageController {

    public PageReference returnlogin() {
        PageReference pr = new PageReference('https://test-eec-lead-portal-test.cs18.force.com/PortalLoginPage');
        return pr;   
    }


    public String username {get; set;}   
       
    public ForgotPageController() {}
  
    public PageReference forgotPassword() {
      boolean success = Site.forgotPassword(username);
      PageReference pr = Page.ForgotPasswordConfirmVFPage;
      pr.setRedirect(false);
      
      if (success) {        
        return pr;
      }
      return null;
    }
}