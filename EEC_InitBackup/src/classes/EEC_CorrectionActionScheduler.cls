global class EEC_CorrectionActionScheduler implements schedulable {
	
	public void execute (SchedulableContext sc) {
		
		String cDate = DateTime.now().format('yyyy-MM-dd');
		
		String sQuery = 'Select Id,Provider_No__r.OwnerId,Inspector_del__c,Number_of_non_compliant_items__c,Number_of_Items_with_Corrective_Actions__c '+
					    'from Inspection__c where Number_of_non_compliant_items__c > 0 and Created_on_the_Web__c = false and '+
						'Corrective_Action_Deadline__c != null and Corrective_Action_Deadline__c = '+cDate;
		EEC_CorrectionAction ca = new EEC_CorrectionAction(sQuery);
        id boccemea = database.executebatch(ca,200);
	}
	
}