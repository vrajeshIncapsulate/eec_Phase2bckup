public class EEC_InspectionItemTriggerHandler {
    private List<Inspection_Item__c> visititems = new List<Inspection_Item__c>();
    private Map<Id,Inspection_Item__c> oldVisitMap = new Map<Id,Inspection_Item__c>();
    RecordType rType = [select Id from RecordType where SobjectType = 'Inspection__c' and DeveloperName = 'Investigation_Visits'];
    //private Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE sObjectType = 'Inspection__c']);
    
    public EEC_InspectionItemTriggerHandler(List<Inspection_Item__c> newList,Map<Id,Inspection_Item__c> oldMap){
        this.visititems = newlist;
        this.oldVisitMap = oldMap;
    } 
     
    
    public void updateRequireFeedback(){        
        Set<id> insids = new Set<Id>();
        Set<Id> invids = new Set<Id>();
        String cname;
        Inspection_Item__c oldII;
        System.debug('List size' + visititems.size());
        for(Inspection_Item__c i : visititems){ 
            oldII = oldVisitMap.get(i.Id); 
            if (i.Inspection_Result__c == 'Non-Compliant' && i.Feedback_Requested__c == false){    
                insids.add(i.Inspection_No__c);        
            }
       }
       if(insids != null){ 
           System.debug('insids-->'+insids);
           Map<Id,Inspection__c> inspMap = new Map<Id,Inspection__c>(
               [SELECT id,Investigation__c,
                (SELECT Id,Date_Implemented__c 
                 FROM Inspection_Items__r 
                 WHERE Inspection_Result__c = 'Non-Compliant' 
                 AND Feedback_Requested__c = true),
                Number_of_Items_with_Corrective_Actions__c,
                Number_of_non_compliant_items__c 
                FROM Inspection__c 
                WHERE id in :insids AND RecordTypeId = :rType.Id]);
            
           System.debug('inspMap.values()'+ inspMap.values());
           for(Inspection__c insp: inspMap.values()){
               if (insp.Investigation__c != null){
                  if((insp.Inspection_Items__r == null) || (insp.Inspection_Items__r != null && insp.Inspection_Items__r.size() == 0)){
                        invids.add(insp.Investigation__c);
                  }    
               }
           }
       }
       if(invids !=null && invids.size() > 0){
           System.debug('invids' + invids);
           Map<Id, Investigation__c> invsMap = new Map<Id,Investigation__c>(
               [SELECT Id,Created_on_the_Web__c,Require_Portal_Feedback__c 
                FROM Investigation__c where Id in :invids ]);
           List<Non_Compliant__c> nonList = new List<Non_Compliant__c>([
               SELECT id FROM Non_Compliant__c 
               WHERE Investigation__c in :invids AND 
               Feedback_Requested__c = true LIMIT 1]);
           //Non_Compliant__c noncomp;
           List<Investigation__c> invlist = new List<Investigation__c>();
           for(Investigation__c inv : invsMap.values()){
              if (inv != null){
                 System.debug('Madhav test 1');
                 if (inv.Created_on_the_Web__c == true){
                     System.debug('Madhav test 2');
                    if (nonList.size()> 0 )             
                    {
                      System.debug('Madhav test 3');
                      break;
                    }
                    else{
                      if (inv.Require_Portal_Feedback__c){ //Mod by LD - Fix for BMMS-227
                          inv.Require_Portal_Feedback__c = false;
                          System.debug('Madhav test 4');
                          invlist.add(inv);
                      }
                    }
                }
             }
           }
           if (invlist != null && invlist.size() > 0 ){
               System.debug('Madhav test 5');
               System.debug('Investigation List' + invlist);
               update invlist;
           }  
       }    
    }
    
    public void SubmissionHistory(){
        list<Submission_History__c> SHlist = new list<Submission_History__c>();
        list<Inspection_Item__c> VIlist = new list<Inspection_Item__c>();
        for(Inspection_Item__c VI : visititems){
            if(VI.Create_History_Record_flag__c == true && oldvisitmap.get(VI.id).Create_History_Record_flag__c==false){
                Submission_History__c SH = new Submission_History__c();
                SH.Visit_Item__c = VI.id;
                SH.RecordTypeId = [select Id from RecordType where Name = 'Visit Corrective Action Plan Submission History' and SobjectType = 'Submission_History__c'].Id;
                system.debug('MMM'+SH.Visit_Item__c);
                SH.Visit__c = VI.Inspection_No__c;
                SH.Correction_Plan__c = VI.Correction_Plan__c;
                SH.Corrective_Actions_Submitter__c = VI.Corrective_Actions_Submitter__c;
                SH.Date_Implemented__c= VI.Date_Implemented__c;
                SH.Date_Corrective_Actions_Received__c= VI.Date_Corrective_Actions_Received__c;
                SH.Corrective_Action_EEC_Feedback__c= VI.Corrective_Action_EEC_Feedback__c;
                SH.Last_Corrective_Action_EEC_Feedback__c=VI.Last_Corrective_Action_EEC_Feedback__c;
                SHlist.add(SH);
                Inspection_Item__c II = new Inspection_Item__c(ID=VI.id);
                II.Create_History_Record_flag__c=false;
                VIlist.add(II);
                
            
            }
         
        }
    if(SHlist.size()>0){
        insert SHlist;
        update VIList;
    
    }   
    
    }
}