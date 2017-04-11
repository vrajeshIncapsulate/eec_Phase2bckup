/**
 * An apex class that views and updates Intervention information.
 */
public without sharing class EEC_UpdateInterventionController {

    public void done() {
        attached=false;
        
    }


   public Boolean attached { get; set; }
   public String attachmentMessage {get;set;}
   public String memberId{ get; set; }    
   
   //public Investigation__c investrec{get;set;}
   public Id interventionId{get;set;}
   public List<Attachment> attachlist{get;set;}
   public PageReference cancel() {
        PageReference pPage = Page.EEC_PortalProviderPage;
        if(memberId != null)  
       		pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
        return pPage;
   }


    public PageReference save() {
    
        if (interventionTrans != Null){
                
                interventionTrans.Status__c ='Submitted';
                interventionTrans.Submission_Date__c = Date.Today();
                update interventionTrans;
                
        }
        PageReference pr = Page.EEC_PortalProviderPage;
        if(memberId != null)  
       		pr.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
        return pr;
    
    }
    
    public Intervention__c  interventionTrans {get;set;}
    
    public EEC_UpdateInterventionController() {
    memberId = ApexPages.currentPage().getParameters().get('member');
    attachmentMessage = '';
    attached=false;
    interventionId = ApexPages.currentPage().getParameters().get('Id');
        
    interventionTrans = [select id,Status__c,Submission_Date__c,Portal_User_Instructions__c,To_Be_Provided_By__c,Investigation__r.Name,Investigation__r.Leader_Name_Text__c,Investigation__r.Leader_Email__c,Investigation__r.Leader_Phone__c
                         from Intervention__c where Id = :interventionId ]; 

	attachlist = [select Id,name,CreatedDate from Attachment where attachment.OwnerId = :UserInfo.getUserId() and attachment.ParentId = :interventionTrans.Id
                       and LastModifiedById = :UserInfo.getUserId() order by LastModifiedDate Desc];
         
    }
    
    public Attachment attachment {
      get {
          if (attachment == null)
            attachment = new Attachment();
            return attachment;
        }
      set;
    }
    
    public void upload() {
      attached = true;   
      if(attachment != null && attachment.name != null){
         attachment.OwnerId = UserInfo.getUserId();
         attachment.ParentId = interventionTrans.Id; // the record the file is attached to
         //attachment.ParentId = investrec.Id; // the record the file is attached to
         attachment.IsPrivate = false;
         attachmentMessage = attachmentMessage + attachment.name + ', ';
         try {
             insert attachment;
             attached = true;
             attachlist = [select Id,name,CreatedDate from Attachment where attachment.OwnerId = :UserInfo.getUserId() and attachment.ParentId = :interventionTrans.Id
                       and LastModifiedById = :UserInfo.getUserId() order by LastModifiedDate Desc];
         } catch (DMLException e) {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
         } finally {
           attachment = new Attachment(); 
         }
  
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));

     }
     else{
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a file to be uploaded'));
     }
  

    
    }
    
}