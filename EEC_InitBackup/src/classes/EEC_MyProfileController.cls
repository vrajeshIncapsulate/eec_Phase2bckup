public with sharing class EEC_MyProfileController {

    public User user { get; set; }
    public Contact contact { get; set; }
    public String isSelfContactMode {get;set;}

    public EEC_MyProfileController(){ 
        isSelfContactMode = ApexPages.currentPage().getParameters().get('selfContactMode');
        refreshUser();
    }

    private void refreshUser(){
        user = [SELECT Id, Email, ContactId, LastName, FirstName FROM User WHERE ID = :UserInfo.getUserId()];
        contact = [SELECT Phone,Salutation,MobilePhone,Title, MailingCity, MailingStreet, MailingState, MailingCountry, MailingPostalCode, LastName, FirstName, OtherStreet, OtherCity, OtherPostalCode, OtherState, Department, Fax, HomePhone, Extension__c FROM Contact WHERE ID = :user.ContactId];
    }
    // Method to return picklist for State dropdown
   public List<SelectOption> getStates() {
      String[] states = new String[]{'Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware', 'District of Columbia','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming'};
      List<SelectOption> statesList = new List<SelectOption>();
      for(String s : states){
          if(contact.MailingState != s)
          statesList.add(new SelectOption(s,s));
      }
      if(contact.MailingState != null)
          statesList.add(0,new SelectOption(contact.MailingState,contact.MailingState));
      return statesList;
   }
    
    public PageReference save(){
        try{
           UserUtil.updateUserContact(
               user.Id, contact.Salutation, contact.Title, contact.FirstName, contact.LastName, contact.MailingStreet, 
               contact.MailingCity, contact.MailingState, contact.MailingCountry, contact.MailingPostalCode, 
               contact.Phone, null, user.Email, contact.OtherStreet, contact.OtherCity, contact.OtherState, 
               contact.OtherPostalCode, contact.HomePhone, contact.Fax, contact.Department, contact.Extension__c
           );
           
           refreshUser();
        }
        catch(Exception e){
            Apexpages.addMessages(e);
        }
        PageReference contactPage = Page.EEC_ContactPage;
      	contactPage.getParameters().put('Id',user.ContactId);
        
        if (isSelfContactMode != null) {
          contactPage.getParameters().put('selfContactMode', isSelfContactMode);  
        }
     
      	contactPage.setRedirect(true);
        return contactPage;
    }
}