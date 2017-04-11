global class EEC_VisitAnnouncedEmailScheduler implements schedulable {
		
	public void execute (SchedulableContext sc) {
		
		String vDate = DateTime.now().addDays(3).format('yyyy-MM-dd');
		//String cDate = DateTime.now().format('yyyy-MM-dd');
		EEC_VisitAnnouncedEmail vae = new EEC_VisitAnnouncedEmail('Select Id,Provider_No__r.Provider_Email__c from Inspection__c where Announced__c = true and Date_of_Visit__c = '+vDate);
        id boccemea = database.executebatch(vae,200);
	}
	
}