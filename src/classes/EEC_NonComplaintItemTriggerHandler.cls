public with sharing class EEC_NonComplaintItemTriggerHandler {
    private List<Non_Compliant__c> noncompitems = new List<Non_Compliant__c>();
    private Map<Id,Non_Compliant__c> oldnoncompMap = new Map<Id,Non_Compliant__c>();
    public EEC_NonComplaintItemTriggerHandler(List<Non_Compliant__c> newList,Map<Id,Non_Compliant__c> oldMap){
        this.noncompitems = newlist;
        this.oldnoncompMap = oldMap;
    } 
    
    
    public void updateRequireFeedback(){        
        Set<id> invids = new Set<Id>();
        Non_Compliant__c oldnc;
        for(Non_Compliant__c i : noncompitems){ 
            oldnc = oldnoncompMap.get(i.Id); 
            if (oldnc.Feedback_Requested__c != i.Feedback_Requested__c){  
                invids.add(i.Investigation__c);        
            }
        }

       
 //      Map<Id, Investigation__c> invsMap = new Map<Id,Investigation__c>([select Id from Investigation__c where Id in :invids and Created_on_the_Web__c = true]);
         List<Investigation__c> invglist = new List<Investigation__c>([select Id,(select Id from Non_Compliant_Item__r where Feedback_Requested__c = true) from Investigation__c where Id in :invids and Created_on_the_Web__c = true]);
         Set<id> invid2 = new Set<Id>();
         for(Investigation__c inv: invglist){
            if((inv.Non_Compliant_Item__r == null) || (inv.Non_Compliant_Item__r != null && inv.Non_Compliant_Item__r.size() == 0)){
                invid2.add(inv.Id);
            }
         }     
         if(invid2 !=null && invids.size() > 0){
           List<Inspection__c> visitlist = new List<Inspection__c>([ select Investigation__c,Number_of_Items_with_Corrective_Actions__c,Number_of_non_compliant_items__c from Inspection__c where Investigation__c in :invid2]);
           Set<Id> invid3 = new Set<Id>();
           System.debug('visitlist ' + visitlist);
           if (visitlist != null && visitlist.size() > 0){
               
              for(Inspection__c insp : visitlist){
                 System.debug('Final update -->' + insp.Number_of_Items_with_Corrective_Actions__c);
                 System.debug('Final update -->' + insp.Number_of_non_compliant_items__c);
                 if (insp.Number_of_Items_with_Corrective_Actions__c >= insp.Number_of_non_compliant_items__c){
                     invid3.add(insp.Investigation__c);
                 }
              }
           }              
            List<Investigation__c> invslist = new List<Investigation__c>([select Require_Portal_Feedback__c from Investigation__c where Id in :invid3 and Require_Portal_Feedback__c = true]);
            List<Investigation__c> updatelist = new List<Investigation__c>();
            if (invslist.size() > 0){
            
               for (Investigation__c inv : invslist){
                   System.debug('Final update -->' + inv.Require_Portal_Feedback__c);
                   if(inv.Require_Portal_Feedback__c){ //Mod by LD - Fix for BMMS-227
                      inv.Require_Portal_Feedback__c = false;
                      updatelist.add(inv);
                   }
               }
            
               if (updatelist != null && updatelist.size() > 0){
                  System.debug('Final update -->');
                  update updatelist;
               }
            }
        } 
        
    }
    public void Submissionhistory(){
        list<Submission_History__c> SHlist = new list<Submission_History__c>();
        list<Non_Compliant__c> NClist = new list<Non_Compliant__c>();
        for(Non_Compliant__c NC : noncompitems){
            if(NC.Create_History_Record_flag__c == true && oldnoncompMap.get(NC.id).Create_History_Record_flag__c==false){
                Submission_History__c SH = new Submission_History__c();
                //SH.Visit_Item__c = NC.id;
                SH.Non_Compliant_Item__c=NC.id;
                SH.RecordTypeId = [select Id from RecordType where Name = 'NC Item Corrective Action Plan Submission History' and SobjectType = 'Submission_History__c'].Id;
                system.debug('MMM'+SH.Visit_Item__c);
                //SH.Visit__c = NC.Inspection_No__c;
                SH.Investigation__c=NC.Investigation__c;
                SH.Correction_Plan__c = NC.Correction_Plan__c;
                SH.Corrective_Actions_Submitter__c = NC.Corrective_Actions_Submitter__c;
                SH.Date_Implemented__c= NC.Date_Implemented__c;
                SH.Date_Corrective_Actions_Received__c= NC.Date_Corrective_Actions_Received__c;
                SH.Corrective_Action_EEC_Feedback__c= NC.Corrective_Action_EEC_Feedback__c;
                SH.Last_Corrective_Action_EEC_Feedback__c=NC.Last_Corrective_Action_EEC_Feedback__c;
                SHlist.add(SH);
                Non_Compliant__c Nonc = new Non_Compliant__c(ID=NC.id);
                NonC.Create_History_Record_flag__c=false;
                NCList.add(NonC);
            }
        }
    if(SHlist.size()>0){
        insert SHlist;
        Update NCList;
    }   
    }
    
    public void updateStatus(){
        Set<String> userNameSet = new Set<String>();
        for(Non_Compliant__c nonComp : noncompitems){
            if(nonComp.Corrective_Actions_Submitter__c!=''&&nonComp.Corrective_Actions_Submitter__c!=null){
                userNameSet.add(nonComp.Corrective_Actions_Submitter__c);
            }
        }
        List<User> portalUsers = new List<User>();
        Set<String> portalUserNames = new Set<String>();
        portalUsers = [select id,Name,IsPortalEnabled from User where Name IN :userNameSet and IsPortalEnabled=true];
        for(User us : portalUsers){
            portalUserNames.add(us.Name);
        }
        for(Non_Compliant__c nonComp : noncompitems){
            if((nonComp.Correction_Plan__c==''||nonComp.Correction_Plan__c==null)&&nonComp.Date_Corrective_Actions_Received__c==null){
                nonComp.Correction_Plan_Status__c='To Collect';
            }else if((nonComp.Correction_Plan__c!=''&&nonComp.Correction_Plan__c!=null)&&nonComp.Date_Corrective_Actions_Received__c!=null&&(!portalUserNames.contains(nonComp.Corrective_Actions_Submitter__c))&&nonComp.Correction_Plan_Status__c!='EEC Accepted'){
                nonComp.Correction_Plan_Status__c='Provider Submitted, EEC to Review';
            }
        
          if(trigger.isUpdate){
                if((oldnoncompMap.get(nonComp.id).Correction_Plan_Status__c)!='EEC Accepted'&&nonComp.Correction_Plan_Status__c=='EEC Accepted'){
                    nonComp.Date_Correction_Plan_Accepted__c = date.Today();
                }else if(nonComp.Correction_Plan_Status__c!='EEC Accepted' && oldnoncompMap.get(nonComp.id).Correction_Plan_Status__c=='EEC Accepted'){
                    nonComp.Date_Correction_Plan_Accepted__c = null;
                }
            }
        }
    }
    
  
   
}