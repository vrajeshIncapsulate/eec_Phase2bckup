trigger EEC_EventTrigger on Event (after insert, after update) {
	
	EEC_EventTriggerHandler it;
	if(Trigger.isInsert){
		it = new EEC_EventTriggerHandler(Trigger.New);
		it.bulkAfter();
     	it.updateTasks();
     	it.updateBeforeVisits();
	    //it.sendVisitEventEmails();
    }
    else if(Trigger.isUpdate){
    	it = new EEC_EventTriggerHandler(Trigger.New, Trigger.oldMap);
    	it.bulkAfter();
    	it.updateAfterVisits();
    }
    
}