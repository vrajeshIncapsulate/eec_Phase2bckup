trigger EEC_LicenseTransactionTrigger on Licensing_Transaction__c (after update) {
	
	if(!EEC_LicenseTransactionTriggerHandler.checkRecursive())
    {
		EEC_LicenseTransactionTriggerHandler ltt = new EEC_LicenseTransactionTriggerHandler(Trigger.new);
		ltt.bulkAfter();
		ltt.updateHouseHoldMembers();
    }
	
}