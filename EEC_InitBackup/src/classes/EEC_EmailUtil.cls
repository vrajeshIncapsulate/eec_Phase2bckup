public with sharing class EEC_EmailUtil {
  
  public String subject = '';
    public String htmlBody = ''; 
    public String plainTextBody = '';
    public Boolean useSignature = false;
    public Boolean SaveAsActivity = false;
    public List<Messaging.EmailFileAttachment> fileAttachments = null;
    public Id templateId;
    public Id whatId;
    public Id targetObjectId; // Contact, Lead, or User.
    public Id orgWideEmailId;
    public List<String> toAddresses; 

    // Default replyTo is current user's email address
  // using a static to save this result across multiple email constructions.
  public static User currentUser {
    get {
      if (currentUser == null) {
        currentUser = [select Email from User where username = :UserInfo.getUserName() limit 1];
      }
      return currentUser;
    } 
    set;
  }
  public String replyTo = currentUser.email; //replyTo defaults to current user's email
    public String senderDisplayName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
    
    public Messaging.SingleEmailMessage singleEmailMessage; 
    
    public Messaging.SendEmailResult[] sendEmail() {
        build();
        return Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmailMessage });
    }
    
    public void build() {
        singleEmailMessage = new Messaging.SingleEmailMessage();
        singleEmailMessage.setTargetObjectId(this.targetObjectId);
        singleEmailMessage.setWhatId(this.whatId);
        singleEmailMessage.setToAddresses(this.toAddresses);
        singleEmailMessage.setUseSignature(this.useSignature);
        singleEmailMessage.setReplyTo(this.replyTo);
        singleEmailMessage.setFileAttachments(this.fileAttachments);
        singleEmailMessage.setSaveAsActivity(this.saveasactivity);
        if(String.isNotBlank(this.orgWideEmailId)){
          singleEmailMessage.setOrgWideEmailAddressId(this.orgWideEmailId);
        }
        else{
          singleEmailMessage.setSenderDisplayName(this.senderDisplayName);
        }
        // use template if one exists, else use html and plain text body
        if (this.templateId == null) {
            singleEmailMessage.setHtmlBody(this.htmlBody);
            singleEmailMessage.setPlainTextBody(this.plainTextBody);
            singleEmailMessage.setSubject(this.subject);
        } else {
            singleEmailMessage.setTemplateId(this.templateId);
        }
        //return this;
    }
    
  
    
}