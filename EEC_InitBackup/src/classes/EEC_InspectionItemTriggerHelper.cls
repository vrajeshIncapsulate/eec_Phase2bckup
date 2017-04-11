public class EEC_InspectionItemTriggerHelper{
    public static Map<Id,Inspection__c> insAccMap;
    public static Boolean flag=false;
    public static void callVisitItems(List<Inspection_Item__c> triggerNewList,Map<id,Inspection_Item__c> oldMap){
        Id stdRecordTypeId = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Standard Visit Item').getRecordTypeId();
        Id nonRecordTypeId = Schema.SObjectType.Inspection_Item__c.getRecordTypeInfosByName().get('Non Standard Visit Item').getRecordTypeId();
        List<Inspection_Item__c> stdItems = new List<Inspection_Item__c>();
        List<Inspection_Item__c> nonItems = new List<Inspection_Item__c>();
        List<Id> insId = new List<Id>();
        
        Set<String> userNameSet = new Set<String>();
        for(Inspection_Item__c insItem : triggerNewList){
            if(insItem.Corrective_Actions_Submitter__c!=''&&insItem.Corrective_Actions_Submitter__c!=null){
                userNameSet.add(insItem.Corrective_Actions_Submitter__c);
            }
        }
        List<User> portalUsers = new List<User>();
        Set<String> portalUserNames = new Set<String>();
        portalUsers = [select id,Name,IsPortalEnabled from User where Name IN :userNameSet and IsPortalEnabled=true ];
        for(User us : portalUsers){
            portalUserNames.add(us.Name);
        }
        
        for(Inspection_Item__c  items : triggerNewList){
            if(items.Inspection_Result__c=='Non-Compliant' && (items.Correction_Plan__c==''||items.Correction_Plan__c==null)&&(items.Date_Corrective_Actions_Received__c==null)){
                items.Correction_Plan_Status__c='To Collect';
            }else if(items.Inspection_Result__c!='Non-Compliant' && items.Correction_Plan_Status__c!=null && items.Correction_Plan_Status__c!='' ){
                items.Correction_Plan_Status__c='';
            }else if(items.Inspection_Result__c=='Non-Compliant' && (items.Correction_Plan__c!=''&&items.Correction_Plan__c!=null)&&(items.Correction_Plan_Status__c!='EEC Accepted')&&(portalUserNames.contains(items.Corrective_Actions_Submitter__c))){
                items.Correction_Plan_Status__c='Provider Submitted, EEC to Review';
            }
            if(trigger.isUpdate){
                if((oldMap.get(items.id).Correction_Plan_Status__c)!='EEC Accepted'&&items.Correction_Plan_Status__c=='EEC Accepted'){
                    items.Date_Correction_Plan_Accepted__c = date.Today();
                }else if(items.Correction_Plan_Status__c!='EEC Accepted' && oldMap.get(items.id).Correction_Plan_Status__c=='EEC Accepted'){
                    items.Date_Correction_Plan_Accepted__c = null;
                }
            }
            insId.add(items.Inspection_No__c);
            if(items.RecordTypeId==stdRecordTypeId){
                stdItems.add(items);
            }
            if(items.RecordTypeId==nonRecordTypeId){
                nonItems.add(items);
            }
        
        }
        insAccMap = new Map<Id,Inspection__c>([select id,Provider_No__c,Provider_No__r.Is_FCC__c,Provider_No__r.Is_GSA__c,Provider_No__r.Is_R_P__c from Inspection__c where ID IN:insId]);
        if(!stdItems.isEmpty()){
            standardVisitItemCheckbox(stdItems);
        }
        if(!nonItems.isEmpty()){
            nonStandardVisitItemCheckbox(nonItems);
        }
    }
    public static void standardVisitItemCheckbox(List<Inspection_Item__c> triggerNewList){
        List<Id> regulation_Id = new List<Id>();
        List<Id> insItemId = new List<Id>();
        List<Id> accId = new List<Id>();
        for(Inspection_Item__c  items : triggerNewList){
            insItemId.add(items.Standard_Inspection_Item__c);
        }
        Map<Id,Standard_Inspection_Item__c> standardMap = new Map<Id,Standard_Inspection_Item__c>([select id,(select id,Regulation__c,Standard_Inspection_Item__c, Regulation__r.FCC_High_Risk_Reg__c,Regulation__r.GSA_High_Risk_Reg__c,Regulation__r.R_P_High_Risk_Reg__c  from Junction_InspRegs__r) from Standard_Inspection_Item__c where ID IN:insItemId]);
        Map<Id,Boolean> comparisonMap = new Map<Id,Boolean>();
        for(Inspection_Item__c item : triggerNewList){  
            Inspection__c ins = insAccMap.get(item.Inspection_No__c);
            for(Junction_InspReg__c reg : standardMap.get(item.Standard_Inspection_Item__c).Junction_InspRegs__r){
                if((reg.Regulation__r.FCC_High_Risk_Reg__c)&&(ins.Provider_No__r.Is_FCC__c)){
                    item.Key_Indicator__c = true;
                }else if((reg.Regulation__r.GSA_High_Risk_Reg__c)&&(ins.Provider_No__r.Is_GSA__c)){
                    item.Key_Indicator__c = true;
                }else if((reg.Regulation__r.R_P_High_Risk_Reg__c)&&(ins.Provider_No__r.Is_R_P__c)){
                    item.Key_Indicator__c = true;
                }else{
                    item.Key_Indicator__c = false;
                }
            }
        }
    }
    
    public static void nonStandardVisitItemCheckbox(List<Inspection_Item__c> triggerNewList){
        List<Id> inspectionId = new List<Id>();
        List<Id> regulationId = new List<Id>();
        for(Inspection_Item__c item : triggerNewList){
            regulationId.add(item.Associated_regulation__c);
         }
        Map<Id,Regulation__c> regulationMap = new Map<Id,Regulation__c>([select id,FCC_High_Risk_Reg__c,GSA_High_Risk_Reg__c,R_P_High_Risk_Reg__c from Regulation__c where Id IN:regulationId]);
        for(Inspection_Item__c item : triggerNewList){
           Inspection__c ins = insAccMap.get(item.Inspection_No__c);
           Regulation__c reg = regulationMap.get(item.Associated_regulation__c);
            if(reg!=null && ins!=null){
                if((reg.FCC_High_Risk_Reg__c)&&(ins.Provider_No__r.Is_FCC__c)){
                    item.Key_Indicator__c = true;
                }else if((reg.GSA_High_Risk_Reg__c)&&(ins.Provider_No__r.Is_GSA__c)){
                    item.Key_Indicator__c = true;
                }else if((reg.R_P_High_Risk_Reg__c)&&(ins.Provider_No__r.Is_R_P__c)){
                    item.Key_Indicator__c = true;
                }else{
                    item.Key_Indicator__c = false;
                }
           }
        }
        
    }
}