global class EEC_batchGetVisitCoordinates implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
	String query;
	global EEC_batchGetVisitCoordinates(String queryString) {
		this.query = queryString;
	}
	global EEC_batchGetVisitCoordinates() {
		this.query = 'SELECT ID, Address_1__c, Address_2__c, City__c, State__c, Zip_Code__c, Status__c FROM Inspection__c';
		query += ' WHERE status__c IN (\'Scheduled\',\'To be scheduled\') AND validAddress__c = true';
		query += ' AND visitLongitude__c = null AND Offline_Lock__c = false AND Visit_Mode_Lock__c = false AND Address_1__c != null AND Zip_Code__c != null LIMIT 1';
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Inspection__c> visits) {
		for(Inspection__c visit : visits){
			Map<String, String> addressParam = new Map<String, String>();
			addressParam.put('street', visit.Address_1__c);	
			addressParam.put('city', visit.City__c);
			addressParam.put('state', visit.State__c);
			addressParam.put('zipCode', visit.Zip_Code__c);

			Map<String, String> visitCoordinates = new Map<String, String>();

			visitCoordinates = EEC_geoCodeUtility.getLatLng(addressParam);
			
			if(visitCoordinates.get('status') == 'OK'){
				visit.visitLatitude__c = visitCoordinates.get('latitude');
				visit.visitLongitude__c = visitCoordinates.get('longitude');
				System.debug('-----> Visit: ' + visit);
			} else{
				System.debug('----->CoordinatesReceived: ' + visitCoordinates);
				visit.validAddress__c = false;
			}
			try{
				Update visit;
			} catch(Exception e){
				System.debug('-----> Visit Update Failed: ' + e.getMessage());
			}
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		Integer visitWithoutCoordinates = [SELECT Count() 
																				FROM Inspection__c 
																				WHERE status__c IN ('Scheduled','To be scheduled') 
																					AND visitLatitude__c = null AND Offline_Lock__c = false 
																					AND Visit_Mode_Lock__c = false AND Address_1__c != null 
																					AND Zip_Code__c != null AND validAddress__c = true];
		if(!Test.isRunningTest() && visitWithoutCoordinates > 0){
			EEC_batchGetVisitCoordinates visitBatch = new EEC_batchGetVisitCoordinates();
			String cronId = System.scheduleBatch(visitBatch, 'EEC_BatchGetVisitCoordinatesCycle', 1);
			System.debug(cronId);
		}
	}

	/*private static Map<String, String> getCoordinatesFromExisting(Inspection__c newVisit){
		Map<String, String> visitCoordinates = new Map<String, String>();
		List<Inspection__c> existingVisit = new List<Inspection__c>();
		try {
			existingVisit = [SELECT ID, visitLatitude__c, visitLongitude__c FROM Inspection__c 
																WHERE Id !=: newVisit.id AND Address_1__c =: newVisit.Address_1__c AND Zip_Code__c =: newVisit.Zip_Code__c
																	AND visitLongitude__c != null limit 1];
		} catch(Exception e){}

		if(existingVisit.size() > 0){
			visitCoordinates.put('latitude', existingVisit[0].visitLatitude__c);
			visitCoordinates.put('longitude', existingVisit[0].visitLongitude__c);
			visitCoordinates.put('status', 'OK');
		} else {
			visitCoordinates.put('status', 'Not found');
		}
		return visitCoordinates;
	}*/
}