trigger EEC_NonComplaintItemRegulationTrigger on Non_Compliant_Item_Regulation__c (after delete, after insert, after update) {
	Map<id,Non_Compliant_Item_Regulation__c> NewMap = Trigger.newMap;
    Map<id,Non_Compliant_Item_Regulation__c> OldMap = Trigger.oldMap;
    if(trigger.Isafter){
      if(Trigger.IsInsert || Trigger.IsUpdate){
       EEC_NonComplaintItemRegulationTgrHandler.UpdateKeyIndicator(NewMap,OldMap);
      }
      if(Trigger.Isdelete){
       EEC_NonComplaintItemRegulationTgrHandler.UpdateKeyOnDelete(NewMap,OldMap);
      }
    }
    
}