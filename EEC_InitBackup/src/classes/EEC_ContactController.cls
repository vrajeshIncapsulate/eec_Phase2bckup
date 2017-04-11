public without sharing class EEC_ContactController {
  
  public Contact contact {get;set;}
  public String backBtnText {get;set;}
  public String profileName {get;set;}  
  public Account acc {get; set;}
  public String memberId {get; set;}  
    
  public EEC_ContactController() {
    String contactId = ApexPages.currentPage().getParameters().get('Id');
    String reqPage = ApexPages.currentPage().getParameters().get('page'); 
    memberId =  ApexPages.currentPage().getParameters().get('member');    
    List<Profile> profiles = [SELECT Name from profile where Id = :userinfo.getProfileId() LIMIT 1]; 
	if(profiles.size() > 0) 
       	profileName = profiles[0].Name;   
    backBtnText = 'Back to Provider';
    // If the contact Id is available.  
    if (!String.IsBlank(contactId)) {
      // Get the contact.
      contact = [
        Select 
          Id, 
          Name,
          Title,
          Role__c,
          Department,
          Email,
          Phone,
          Extension__c,
          MobilePhone,
          Fax,
          Salutation,
          HomePhone,
          MailingStreet,
          MailingCity,
          MailingState,
          MailingCountry,
          MailingPostalCode,
          OtherStreet,
          OtherCity,
          OtherState,
          OtherCountry,
          OtherPostalCode
        From Contact 
        Where Id = :contactId
      ];
      
      Account[] accounts = [SELECT Id,Recordtype.Name 
                            FROM Account 
                            WHERE ID in (SELECT Accountid FROM User WHERE id = :Userinfo.getUserId()) LIMIT 1 ];
      if(accounts.size() > 0){
          acc = accounts[0];
          if(reqPage != null){backBtnText = 'Back to Home Page';}
          if (acc.Recordtype.Name.contains('Umbrella')){
            backBtnText = 'Back to Umbrella';
          }
          if(String.isNotBlank(memberId)){
              backBtnText = 'Back to Provider';
              memberId = EncodingUtil.urlEncode(EEC_Util.encryptGetParam(memberId), 'UTF-8');
          }
          if(acc.Recordtype.Name.contains('Assistant')){
              backBtnText = 'Back to Assistant';
          }
        } 
    }
  }
    
  public String getAddress() {
    String address = '';
    // Get the Contacts address.        
    if (contact.MailingStreet != null) {
      address += contact.MailingStreet + ', ';
    } 
        
    if (contact.MailingCity != null) {
      address += contact.MailingCity + ', ';
    }
        
    if (contact.MailingState != null) {
      address += contact.MailingState + ', ';
    }
      
    if (contact.MailingCountry != null) {
      address += contact.MailingCountry + ', ';
    }
        
    if (contact.MailingPostalCode != null) {
      address += contact.MailingPostalCode;
    }
    return address;      
  }
    
  public String getOtherAddress() {
    String address = '';
    // Get the other Contact Address.
    if (contact.OtherStreet != null) {
      address += contact.OtherStreet + ', ';
    } 
        
    if (contact.OtherCity != null) {
      address += contact.OtherCity + ', ';
    }
        
    if (contact.OtherState != null) {
      address += contact.OtherState + ', ';
    }
      
    if (contact.OtherCountry != null) {
      address += contact.OtherCountry + ', ';
    }
        
    if (contact.OtherPostalCode != null) {
      address += contact.OtherPostalCode;
    }   
    return address;
  }
    
  public Boolean getIsSelf() {
    User conID = [SELECT ContactId FROM User WHERE Id =: Userinfo.getUserId() limit 1];  
    if (conID.ContactId == contact.Id) {
      return true;
    }
	return false;      
  }
  public Boolean getUmbrellaMemberId(){
    String memberId =  ApexPages.currentPage().getParameters().get('member');  
      
    if (!String.isBlank(memberId)) {
      return true;     
    }
    return false;  
  }  
  public Boolean getIsSelfContactMode() {
    String contactMode = ApexPages.currentPage().getParameters().get('selfContactMode');
      
    if (!String.isBlank(contactMode)) {
      return Boolean.valueOf(contactMode);     
    }
    return false;
  }
}