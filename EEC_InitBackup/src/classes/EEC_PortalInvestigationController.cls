public with sharing class EEC_PortalInvestigationController {
    
  public Investigation__c invest {get;set;}
  public List<Inspection__c> visits {get;set;}
  public List<NoteAndAttachment> notesAndAttachments {get;set;}
  public List<Non_Compliant__c> nonCompliants {get;set;} 
  public List<Inspection_Item__c> iitems {get; set;} 
  public List<Inspection__c> lstVisits {get;set;}    
  public Map<String, String> attachmentMap {get;set;}
  public Account acc{get;set;}  
  public String invId{get;set;}  
  public String memberId{ get; set; }   
    
  public EEC_PortalInvestigationController() {
    memberId = ApexPages.currentPage().getParameters().get('member');
    if(String.isNotBlank(memberId)){
	  List<Account> accList = [SELECT Id FROM Account WHERE ID =: memberId LIMIT 1];  	
      if(accList != null && accList.size() > 0){
          acc = accList.get(0);
      }
    }else{  
        List<Account> accList = [SELECT Id FROM Account WHERE ID in (SELECT Accountid FROM user WHERE Id = :Userinfo.getUserId()) LIMIT 1 ];  
        if(accList != null && accList.size() > 0){
            acc = accList.get(0);
        }
    }
    invId = ApexPages.currentPage().getParameters().get('id');
    attachmentMap = new Map<String, String>{'CoverLetter' => 'null','NonCompliance' => 'null','Narrative' => 'null'};   
     
    if ( invId != NULL) {
      invest = [
        Select  
          Id, 
          Name, 
          Investigation_Status__c, 
          Closed_Date__c, 
          Facility_Description__c,
          Reason_for_Investigation__c,
          Investigation_Activities__c,
          Determinations__c,
          Investigation_Findings__c,
          Non_compliances__c,
          (Select Id, IsNote, Title From NotesAndAttachments ORDER BY LastModifiedDate DESC)
        From Investigation__c 
        Where Id = :invId
      ];
      notesAndAttachments = invest.NotesAndAttachments;
      if (notesAndAttachments != null) {  
        
        for (NoteAndAttachment attachment : notesAndAttachments) {
         System.debug('-----> notesAndAttachments: ' + notesAndAttachments);
          try {
            if (attachmentMap.get('CoverLetter') == 'null' || attachmentMap.get('NonCompliance') == 'null' || attachmentMap.get('Narrative') == 'null') {  
              String[] titleSplit = attachment.Title.split('-');
              String type = '';
             
              if(titleSplit != null && titleSplit.size() > 0) {
                type = titleSplit[0];          
              } 
              if (attachmentMap.containsKey(type) && attachmentMap.get(type) == 'null') {  
                attachmentMap.put(type, attachment.Id);
              }
            } else {
              break;
            }
          } catch(Exception e) {
            System.debug('Error: ' + e.getMessage());        
          }
        }
      }
    } else {
      invest = null;
    }
   
    lstVisits = [SELECT Id, Name, Status__c, Date_of_Visit__c, Time_of_Visit__c, Inspector_del__r.Name, Number_of_non_compliant_items__c From Inspection__c Where Investigation__c = :invId AND Status__c = 'Closed'];  
  	nonCompliants = [SELECT Id, Name, Observations__c, Correction_Plan__c, Date_Implemented__c, Corrective_Actions_Submitter__c, Date_Corrective_Actions_Received__c From Non_Compliant__c Where Investigation__c = :invId]; 
	iitems = [SELECT Id, Name,Observations__c,Correction_Plan__c,Date_Implemented__c,Corrective_Actions_Submitter__c,Date_Corrective_Actions_Received__c FROM Inspection_Item__c WHERE Inspection_No__r.Investigation__c =: invId AND Inspection_Result__c = 'Non-Compliant'];
      
  }
  public PageReference returnProvider() {
    PageReference pPage = page.EEC_PortalProviderPage;
    if(memberId != null)  
       pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
    return pPage;
  }  
    
  public List<Inspection__c> getVisits(String Id) {
    // TODO: Status must be closed.
  	return [Select Id, Name, Status__c, Date_of_Visit__c, Time_of_Visit__c, Inspector_del__r.Name, Number_of_non_compliant_items__c From Inspection__c Where Investigation__c = :Id AND Status__c = 'Closed'];
  }
    
  public List<Non_Compliant__c> getNonCompliants(String Id) {
  	return [Select Id, Name, Observations__c, Correction_Plan__c, Date_Implemented__c, Corrective_Actions_Submitter__c, Date_Corrective_Actions_Received__c From Non_Compliant__c Where Investigation__c = :Id];   
  }
}