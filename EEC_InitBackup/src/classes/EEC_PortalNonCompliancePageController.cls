public without sharing class EEC_PortalNonCompliancePageController {
 
   public List<Inspection_Item__c> visititems {get;set; }
   public List<Inspection__c> relatedVisits {get; set;}
   public List<InspectionListWrapper> iiWrapperList {get;set;}
   public Map<ID, InspectionListWrapper> iiWrapperListOriginal {get;set;}
   public List<ComplainceListWrapper> ncWrapperList {get;set;}
   public List<Non_Compliant__c>  noncompitems {get;set; }
   public Integer valcount {get;set; }
   public ID accountid {get; private set;}
   public Account provider {get; private set;}
   public String memberId {get;set;}
       
   public EEC_PortalNonCompliancePageController() {  
       memberId = ApexPages.currentPage().getParameters().get('member');
       iiWrapperListOriginal = new Map<ID, InspectionListWrapper>();
       if(String.isNotBlank(memberId)){
           accountid = memberId;
           //memberId = EEC_Util.encryptGetParam(EncodingUtil.urlDecode(memberId, 'UTF-8'));
       }
       else{
           List<Account> tempAccount = [Select Id From Account Where ID in (Select Accountid From User Where id = :Userinfo.getUserId()) Limit 1];
           
           if (tempAccount != null && tempAccount.size() == 1) {
             accountid = tempAccount.get(0).Id;    
           }
       }
       if(String.isBlank(accountid)){
           accountid = ApexPages.currentPage().getParameters().get('accountid');
       }

       if(String.isnotBlank(accountid))
       {
           provider = [select Id, Owner.Email,name from Account where Id = :accountId];
           getitems();
           //getnoncompitems();
       }                 
                  
   }   
   public PageReference returnProvider() {
    PageReference pPage = page.EEC_PortalProviderPage;
    if(memberId != null)  
       pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
    return pPage;
  }
    
   public void getitems(){    
         
        iiWrapperList = new List<InspectionListWrapper>();
        Map<Id,Map<String,String>> iregulationMap = new Map<Id,Map<String,String>>();
        Map<String,String> jiMap;
        
        visititems = [select id,Recordtype.Name,Correction_Plan_Status__c ,Observations__c,Corrective_Action_EEC_Feedback__c, Standard_Inspection_Item__c,Associated_regulation__c,Associated_regulation__r.name,Inspection_No__c,Inspection_No__r.Name,Inspection_No__r.Date_Of_Visit__c,Correction_Plan__c,
                         Date_Implemented__c from Inspection_Item__c where Inspection_No__r.Provider_No__c = :accountId and To_Review_on_Portal__c = true limit 50 ];
           
           Set<id> relatedVisitIdSet = new Set<Id>();
           for(Inspection_Item__c ii : visititems){
              relatedVisitIdSet.add(ii.Inspection_No__c);
           }
           relatedVisits = [SELECT ID, Status__c FROM Inspection__c WHERE Id IN :relatedVisitIdSet];
          
           Set<Id> siSet = new Set<Id>(); 
         
                        
           if(visititems != null && visititems.size() > 0){

                for(Inspection_Item__c ii : visititems){
                    if(ii.RecordType.Name == 'Standard Visit Item'){
                        siSet.add(ii.Standard_Inspection_Item__c);
                    }
                }
           
               for(Junction_InspReg__c jir : [select Id,Regulation__c,Standard_Inspection_Item__c,Regulation__r.name from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]){
                  if(iregulationMap.containsKey(jir.Standard_Inspection_Item__c)){
                     iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.name+',', jir.Regulation__c);

                  }
                  else{
                     jiMap = new Map<String,String>();
                     jiMap.put(jir.Regulation__r.name+',', jir.Regulation__c);
                     iregulationMap.put(jir.Standard_Inspection_Item__c,jiMap);
                
                  }
               }
               Integer rowIndex = 0;          
               for(Inspection_Item__c ii : visititems){               
                   iiWrapperList.add(new InspectionListWrapper(rowIndex,ii,iregulationMap));                   
                   rowIndex = rowIndex + 1;
               }
           }
                                              
             
        ncWrapperList = new List<ComplainceListWrapper>();
     
        noncompitems = [select id,Name,Recordtype.Name,Correction_Plan_Status__c,Observations__c,Corrective_Action_EEC_Feedback__c,Investigation__r.Investigation_Type__c,Investigation__r.name,Correction_Plan__c,Date_Implemented__c
                           from Non_Compliant__c where Investigation__r.Provider_No__c = :accountId and To_Review_on_Portal__c = true limit 50 ];
           Set<Id> ncSet = new Set<Id>();
          
           if(noncompitems != null && noncompitems.size() > 0){

                for(Non_Compliant__c nc : noncompitems){
                    ncSet.add(nc.id);
                    
                }
               Map<String,String> ncMap; 
               Map<Id,Map<String,Id>> ncregulationMap = new Map<Id,Map<String,String>>();
               for(Non_Compliant_Item_Regulation__c ncr : [select Id,Non_Compliant_Item__c,Regulation__c,Regulation__r.name from Non_Compliant_Item_Regulation__c where Non_Compliant_Item__c in :ncSet]){
                  if(ncregulationMap.containsKey(ncr.Non_Compliant_Item__c)){
                     ncregulationMap.get(ncr.Non_Compliant_Item__c).put(ncr.Regulation__r.name+',', ncr.Regulation__c);

                  }
                  else{
                     ncMap = new Map<String,String>();
                     ncMap.put(ncr.Regulation__r.name+',', ncr.Regulation__c);
                     ncregulationMap.put(ncr.Non_Compliant_Item__c,ncMap);
                
                  }
               }
               Integer rowIndex = 0;          
               for(Non_Compliant__c nc : noncompitems){               
                   iiWrapperList.add(new InspectionListWrapper(rowIndex,nc,ncregulationMap));                   
                   rowIndex = rowIndex + 1;
               }
          }
             
       if((visititems == null && visititems.size() == 0) && (noncompitems == null && noncompitems.size() == 0)){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Currently, there is no non-compliance that requires your feedback.'));           
       }
       if(iiWrapperListOriginal.size() == 0){
          System.debug('-------> Getting original values');
          for(InspectionListWrapper ilw : iiWrapperList){
            iiWrapperListOriginal.put(ilw.id, ilw);
          }
       }

   }



  public class InspectionListWrapper{
       
    public Id Id {get;set;}
    public String visitname {get;set;}
    public Integer rowIndex { get; set; }
    public String Type {get; private set;}
    public Map<String,String> regulationMap {get; set;}
    public Date dateofvisit {get;set;}
    public String implementdate {get;set;}
    public String observations {get;set;}
    public String correctionPlan {get;set;}
    public Inspection_Item__c inspItem {get;set;}
    public String name {get;set;}  
    public String InvestType {get; private set;}
    public Non_Compliant__c compItem {get;set;}
    public String ncFeedback {get; set;}  
    public String viFeedback {get; set;}
    public String Status{get; set;}
    
    public InspectionListWrapper (Integer rowIndex, Inspection_Item__c insp,Map<Id, Map<String,String>> iRegMap) {
         this.Id = insp.Id;
         this.rowIndex = rowIndex;
         this.Type = insp.RecordType.Name;
         this.status = insp.Correction_Plan_Status__c;
         this.regulationMap = null;
         if(this.Type == 'Standard Visit Item' && insp.Standard_Inspection_Item__c != null){
              this.regulationMap = iRegMap.get(insp.Standard_Inspection_Item__c);
         }
         else{
              this.regulationMap = new Map<String,String>();
              if(insp.Associated_regulation__c != null){
                this.regulationMap.put(insp.Associated_regulation__r.name,insp.Associated_regulation__c);
              }
            }
            System.debug('********regulationMap-- '+this.regulationMap);
            this.visitname = insp.Inspection_No__r.Name;
            this.implementdate = insp.Date_Implemented__c != null ? insp.Date_Implemented__c.format() : String.valueOf(insp.Date_Implemented__c);
             this.dateofvisit = insp.Inspection_No__r.Date_Of_Visit__c;
            this.observations = insp.observations__c;
            this.correctionPlan = insp.correction_plan__c;
            this.inspItem = insp;
            this.viFeedback = insp.Corrective_Action_EEC_Feedback__c;
        }
       
      public InspectionListWrapper (Integer rowIndex, Non_Compliant__c ncomp,Map<Id, Map<String,String>> nRegMap) {
         this.Id = ncomp.Id;
         this.rowIndex = rowIndex;
         this.Type = ncomp.RecordType.Name;
         this.InvestType = ncomp.Investigation__r.Investigation_Type__c;
         this.regulationMap = null;
         if(ncomp.Name != null){
              this.regulationMap = nRegMap.get(ncomp.id);
         }
            System.debug('********Non Complaince regulationMap-- '+this.regulationMap);
            this.name = ncomp.Investigation__r.name;
            this.implementdate = ncomp.Date_Implemented__c != null ? ncomp.Date_Implemented__c.format() : String.valueOf(ncomp.Date_Implemented__c);
            this.observations = ncomp.observations__c;
            this.correctionPlan = ncomp.correction_plan__c;
            this.compItem = ncomp;
            this.ncFeedback = ncomp.Corrective_Action_EEC_Feedback__c;
        }
        
    }
    public class ComplainceListWrapper{
       
    public Id Id {get;set;}
    public String name {get;set;}
    public Integer rowIndex { get; set; }
    public String Type {get; private set;}
    public String InvestType {get; private set;}
    public Map<String,String> regulationMap {get; set;}
    public String   implementdate {get;set;}
    public String observations {get;set;}
    public String correctionPlan {get;set;}
    public Non_Compliant__c compItem {get;set;}
    
    
    public ComplainceListWrapper(Integer rowIndex, Non_Compliant__c ncomp,Map<Id, Map<String,String>> nRegMap) {
         this.Id = ncomp.Id;
         this.rowIndex = rowIndex;
         this.Type = ncomp.RecordType.Name;
         this.InvestType = ncomp.Investigation__r.Investigation_Type__c;
         this.regulationMap = null;
         if(ncomp.Name != null){
              this.regulationMap = nRegMap.get(ncomp.id);
         }
            System.debug('********Non Complaince regulationMap-- '+this.regulationMap);
            this.name = ncomp.Investigation__r.name;
            this.implementdate = ncomp.Date_Implemented__c != null ? ncomp.Date_Implemented__c.format() : String.valueOf(ncomp.Date_Implemented__c);
            this.observations = ncomp.observations__c;
            this.correctionPlan = ncomp.correction_plan__c;
            this.compItem = ncomp;
            
        }
        
    }
    
    private void saveInspectionItems(){
    List<Inspection_Item__c> updateiiList = new List<Inspection_Item__c>();
    List<Non_Compliant__c>   updatencList = new List<Non_Compliant__c>();
    //numberItemsNonSelected = 0;
    Integer iiCount = 0;
    Integer ncCount = 0;
    if(iiWrapperList != null){
      Inspection_Item__c iItem;
      for(InspectionListWrapper ilw : iiWrapperList){
          if(ilw.inspItem != null && ilw.Status!='EEC Accepted'){ 
              iItem = new Inspection_Item__c();
              iItem.Id = ilw.Id;
              iItem.Correction_Plan_Status__c ='Provider Submitted, EEC to Review';
              iItem.correction_plan__c = ilw.correctionPlan;
              System.debug('----> Date Implemented: ' + ilw.implementdate);
              iItem.Date_Implemented__c = (!String.isBlank(ilw.implementdate) ? Date.parse(ilw.implementdate) : null);
              if(String.isNotBlank(iItem.correction_plan__c)&& iItem.Date_Implemented__c == null){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"Date Correction is Implemented" is required if "Correct Plan" is entered in "Statement of Non Compliance Table from Visits" section'));
                return;
              }
              if(String.isBlank(iItem.correction_plan__c) && iItem.Date_Implemented__c != null){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"Correct Plan" is required if "Date Correction is Implemented" is entered in "Statement of Non Compliance Table from Visits" section'));
                return;
              }

              if(String.isNotBlank(iItem.correction_plan__c)){
                iiCount ++;
              }
              updateiiList.add(iItem);
          }
          else if(ilw.compItem != null && ilw.Status!='EEC Accepted'){
              Non_Compliant__c cItem ;
              cItem = new Non_Compliant__c();
              cItem.Id = ilw.Id;
              cItem.Correction_Plan_Status__c ='Provider Submitted, EEC to Review';
              cItem.correction_plan__c = ilw.correctionPlan;
              cItem.Date_Implemented__c = (!String.isBlank(ilw.implementdate) ? Date.parse(ilw.implementdate) : null);
              if(String.isNotBlank(cItem.correction_plan__c) && cItem.Date_Implemented__c == null){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"Date Correction is Implemented" is required if "Correct Plan" is entered in "Statement of Non Compliance Table from Other Sources" section'));
                return;
              }
              if(String.isBlank(cItem.correction_plan__c) && cItem.Date_Implemented__c != null){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"Correct Plan" is required if "Date Correction is Implemented" is entered in "Statement of Non Compliance Table from Other Sources" section'));
                return;
              }
              if(String.isNotBlank(cItem.correction_plan__c)){
                ncCount ++;
              }
              updatencList.add(cItem);
          }
        }
     }
     /*if(ncWrapperList != null){
       Non_Compliant__c cItem ;
       for(ComplainceListWrapper clw : ncWrapperList){
          cItem = new Non_Compliant__c();
          cItem.Id = clw.Id;
          cItem.correction_plan__c = clw.correctionPlan;
          cItem.Date_Implemented__c = (!String.isBlank(clw.implementdate) ? Date.parse(clw.implementdate) : null);
          if(String.isNotBlank(cItem.correction_plan__c) && cItem.Date_Implemented__c == null){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"Date Correction is Implemented" is required if "Correct Plan" is entered in "Statement of Non Compliance Table from Other Sources" section'));
            return;
          }
          if(String.isBlank(cItem.correction_plan__c) && cItem.Date_Implemented__c != null){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '"Correct Plan" is required if "Date Correction is Implemented" is entered in "Statement of Non Compliance Table from Other Sources" section'));
            return;
          }
          if(String.isNotBlank(cItem.correction_plan__c)){
            ncCount ++;
          }
          updatencList.add(cItem);
        }
      }*/
        
      if(updatencList.size() > 0){
          update updatencList;
      }
      

      if(updateiiList.size() > 0){

          update updateiiList;
          System.debug('-------> Updating Inspection Items');
          for(Inspection__c visit : relatedVisits){
            if(visit.Status__c == 'Report Sent to Provider, Awaiting feedback'){
            
              List<Inspection_Item__c> iiList = [SELECT ID, Inspection_Result__c, To_Review_on_Portal__c, Date_Implemented__c
                                              FROM Inspection_Item__c 
                                              WHERE Inspection_No__c = :visit.Id AND Inspection_Result__c = 'Non-Compliant'
                                                AND To_Review_on_Portal__c = true];
              Integer ncToReviewOnPortal = 0;
              Integer ncDateImplementedNull = 0;
              for(Inspection_Item__c ii : iiList){
                if(ii.To_Review_on_Portal__c = true){
                  ncToReviewOnPortal++;
                }
                if(ii.Date_Implemented__c == null){
                  ncDateImplementedNull++;
                }
              }
              if(ncToReviewOnPortal == 0 && ncDateImplementedNull == 0){
                visit.Status__c = 'Feedback received, to review';
                Update visit;
              }
            }
          }
      }
      
      if((iiCount + ncCount == updateiiList.size() + updatencList.size()) && iiCount + ncCount > 0){
          sendEmail();
      }
        
      getitems();
  }
  
  public PageReference Save(){
    saveInspectionItems();
    if(memberId != null)  
       ApexPages.currentPage().getParameters().put('member',memberId);  
    return null;
  }
  
  public PageReference Cancel(){
    return null;
  }
  
  private void sendEmail(){
    EEC_EmailUtil email = new EEC_EmailUtil();   
    OrgWideEmailAddress owa = [SELECT id, Address FROM OrgWideEmailAddress WHERE DisplayName  = 'EEC LEAD Alert'];  
    email.toAddresses = new List<String>();
    String[] toAddress = new String[1];
    toAddress[0] = provider.Owner.Email;
    //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage ();
    email.saveAsActivity = false;
    email.toAddresses.add(toAddress[0]);
    //email.senderDisplayName = 'EEC - Correction Action to Review';
    //email.targetObjectId = provider.OwnerId;
    email.orgWideEmailId = owa.Id; 
    email.subject = 'New corrective plan submitted';  
    //email.setTemplateId(et.id);  
    String baseURL = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
    String url = 'https://' + baseURL + '/' + provider.Id;  
    String emailBody = 'Hello\n\nA corrective action plan from ' + provider.name + ' awaits your review and approval.\n\nPlease login to Salesforce and review the visit or investigation.\n\n' + url;
    email.plainTextBody = emailBody;
    email.sendEmail();
      
  }
  
}