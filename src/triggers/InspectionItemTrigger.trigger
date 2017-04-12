trigger InspectionItemTrigger on Inspection_Item__c (before insert, before update) {
    //GenerateCertificatePDF.generateContactPDF();
    if(!EEC_InspectionItemTriggerHelper.flag){
        EEC_InspectionItemTriggerHelper.flag = true;
        if(trigger.isInsert){
            EEC_InspectionItemTriggerHelper.callVisitItems(trigger.new,null);        
        }else{
            EEC_InspectionItemTriggerHelper.callVisitItems(trigger.new,trigger.oldMap);        
        }
    }
}