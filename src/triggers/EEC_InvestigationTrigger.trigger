trigger EEC_InvestigationTrigger on Investigation__c (after insert, before insert, before update, after update) {
    Map<Id, Investigation__c> nMap = new Map<Id, Investigation__c>();
    
    if(Trigger.isInsert){
        for(Investigation__c inv : Trigger.new){
            nMap.put(inv.id, inv);
        }
    } else {
        nMap.putAll(Trigger.newMap);
    }

    EEC_InvestigationTriggerHandler ith = new EEC_InvestigationTriggerHandler(
        nMap,
        Trigger.oldMap != NULL ? Trigger.oldMap : new Map<ID, Investigation__c>()
    );
    
    if(Trigger.isBefore){
        ith.updateClosedInvestigationsBefore();
        ith.updateLeaderHeirarchy();
    }
    
   /* if(Trigger.isAfter){ 
        ith.updateClosedInvestigationsAfter();
    }
    */
    
    if (Trigger.isUpdate && Trigger.isAfter) {
      if(EEC_InvestigationTriggerHandler.FirstRun){	
      	  ith.updateClosedInvestigationsAfter(); //Mod by LD - Fix for BMMS-237
	      ith.checkVisitsForPublishedToWeb();
	      EEC_InvestigationTriggerHandler.FirstRun = false;
      }

    }
}