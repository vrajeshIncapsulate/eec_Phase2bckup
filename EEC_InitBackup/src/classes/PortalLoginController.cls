/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class PortalLoginController {

    
    global String username{get;set;}
    global String password{get;set;}
    global PortalLoginController () {}
    
    global PageReference login() {
        if (username.length() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter your Username'));
            return null;   
        }
        else
        if (password.length() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter your Password'));
            return null;   
        }
        else
            return Site.login(username,password,'https://cs18.salesforce.com/home/home.jsp');
    }
    global PageReference forget(){
        PageReference pr = new PageReference('/ForgotPage');
        return pr;
         
   }
}