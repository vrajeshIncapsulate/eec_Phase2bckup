global class EEC_InvestigationCorrectionScheduler implements schedulable {
	
	public void execute (SchedulableContext sc) {
		
		String cDate = DateTime.now().format('yyyy-MM-dd');
		
		String sQuery = 'Select Id,Provider_No__r.OwnerId,(select Id, Feedback_Requested__c from Non_Compliant_Item__r where Feedback_Requested__c = true) from Investigation__c '+
						'where Created_on_the_Web__c = false and Corrective_Actions_Reminder_Date__c != null and Corrective_Actions_Reminder_Date__c = '+cDate;
		EEC_InvestigationCorrectionAction ca = new EEC_InvestigationCorrectionAction(sQuery);
        id boccemea = database.executebatch(ca,200);
	}

}