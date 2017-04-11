trigger RestraintReportTempTrigger on RestraintReportTemp__c (after insert) {
	
	RestraintReportTriggerHelper.bulkRestraintReport(trigger.new);

}