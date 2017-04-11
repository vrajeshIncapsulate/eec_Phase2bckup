trigger EEC_TaskTrigger on Task (after insert) {

	EEC_TaskTriggerHandler ett = new EEC_TaskTriggerHandler(Trigger.new);
	ett.bulkAfter();
	ett.updateLeads();
}