trigger EEC_UserTrigger on User (after insert, after update) {
	
	EEC_UserTriggerHandler eut = new EEC_UserTriggerHandler(Trigger.new,Trigger.oldMap);
	eut.bulkAfter();
	if(Trigger.isInsert){
		eut.updateActiveAccounts();
	}
	else if(Trigger.isUpdate){
		eut.updateInActiveAccounts();
	}
}