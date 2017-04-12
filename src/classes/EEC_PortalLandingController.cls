public without sharing class EEC_PortalLandingController {
   
 //private String loggedInUser;//variable to store the logged in user id.
 private Account acc;
 public User licensor {get;set;}
 public Lead_Configuration__c leadConfig {get;set;}   
 public String profileName {get;set;}  
 
 public Boolean accessProviderFlag {get;set;}
 public Boolean accessUmbrellaFlag {get;set;}
 public void EEC_PortalLandingController(){

   accessProviderFlag=false;
   accessUmbrellaFlag=false;
   actionMethod();
 }
    
 public PageReference gotoPersonalPage() {
   Id uid = Userinfo.getUserId();
   USER u = [Select Id,ContactId from User where Id =: uid limit 1];
   PageReference contactPage = Page.EEC_ContactPage;
   contactPage.getParameters().put('Id',u.ContactId);
   contactPage.getParameters().put('page','home'); 
   contactPage.setRedirect(true);
   return contactPage;       
 }

 public pagereference actionMethod() {
   List<Profile> profiles = [SELECT Name from Profile where Id = :userinfo.getProfileId() LIMIT 1]; 
   if(profiles.size() > 0) 
		profileName = profiles[0].Name;  
     
   acc = [select Id, Name, RecordType.Name, License_Status__c, OwnerId From Account where ID in (select Accountid from user  where id = :Userinfo.getUserId()) limit 1 ]; 
   //where id = '00511000002hRqxAAE') limit 1];
   licensor = [Select Id, Name, Email From User Where Id = :acc.OwnerId Limit 1];
  
   if (acc <> null ){       
     If (acc.Recordtype.Name.contains('Umbrella')){
       accessUmbrellaFlag = true;
     }else{
       accessProviderFlag = true;
     }
   }
     
   // Get the LEAD config.
   Lead_Configuration__c[] leadConfigs = [Select Id,Name, Portal_Home_Useful_Links__c, Portal_Home_Welcome__c, Portal_Home_Latest_News__c From Lead_Configuration__c Where Name = :acc.RecordType.Name];
	if(leadConfigs.size() > 0)
    {
        leadConfig = leadConfigs[0];
    }
   //   return accessProviderFlag;
   return null;  
 }
    
    public Lead_Configuration__c getLeadConfiguration() {
        return leadConfig;
    }
 
    public Account getAccount(){
        return acc;
      }
               
    public PageReference goToProviderPage() {    
        PageReference pPage = page.EEC_PortalProviderPage;
        return pPage;
    }
    public PageReference goToUmbrellaPage() {
        PageReference pPage = page.EEC_Umbrella;
        return pPage;
    }
    
    public PageReference goToSubmitNewTransaction() {
        PageReference pPage = page.EEC_TransactionIntroduction;
        return pPage;
    }
   
   public PageReference noncomp() {
        PageReference pPage = page.EEC_PortalNonCompliancePage;
        return pPage;
   
    } 
   public PageReference investigationPage() {
        PageReference pPage = page.EEC_Interventionpage;
        return pPage;
        
    }
     public PageReference goToSubmitNewIncident() {
        PageReference pPage = page.EEC_CasesIncidentsPage;
        return pPage;
    }
    
    public PageReference goToSubmitNewRestraint() {
        PageReference pPage = Page.EEC_RestraintReport;
        return pPage;
    }
}