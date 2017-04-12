trigger EEC_VisitTrigger on Inspection__c (before insert, after insert, after update, before update) {
     
    // All insert triggers
    if(Trigger.isInsert){
        EEC_VisitTriggerHandler it = new EEC_VisitTriggerHandler(Trigger.New);
        if(Trigger.isAfter){
        	it.createVisitTasks();
        }
        else{
	        it.bulkBefore();
	        it.updateVisit();
            it.updateVisitCoordinatesBefore();
        }
        
    }
    // All update triggers
    else if(Trigger.isUpdate && Trigger.isBefore){ 
        EEC_VisitTriggerHandler it = new EEC_VisitTriggerHandler(Trigger.New, Trigger.oldMap);
        it.updateClosedActivitySummary();
        it.updateVisitCoordinatesBefore();
    }
    // All update triggers; only after records have been saved.
    else if(Trigger.isUpdate && Trigger.isAfter){
        EEC_VisitTriggerHandler it = new EEC_VisitTriggerHandler(Trigger.New,Trigger.oldMap);
        it.bulkAfter();
        it.closeCancelledTasks();
        // Check for 'Published on Web' field and update any visit items accordingly.
        it.checkItemsForPublishedToWeb(Trigger.newmap.keyset());
        // Check for update that turns visit into Master Visit status. Update all tasks accordingly.
        it.checkForNewMasterVisit();
        // Apply multiple conditionals to Slave Visits.
        it.checkMasterVisitForChanges();              
    }
    
    public class applicationException extends Exception {}
}