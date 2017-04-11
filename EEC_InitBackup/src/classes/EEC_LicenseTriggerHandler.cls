public with sharing class EEC_LicenseTriggerHandler {
	/*List<License__c> newInspectionList;
	Map<Id,Account> providerMap;
	public EEC_LicenseTriggerHandler(List<License__c> newList){
		this.newInspectionList = newList;
	}
	
	public void bulkAfter(){
		providerMap = new Map<Id,Account>();
		Set<Id> providerSet = new Set<Id>();
		for(License__c license : newInspectionList){
			providerSet.add(license.Provider_no__c);
		}
		
		providerMap = new Map<Id,Account>([select Id, Provider_no__c, OwnerId,Renewal_Date__c from Account where Id in :providerSet]);
	}
	
	public void createVisit(){
		
		List<Inspection__c> createVisitList = new List<Inspection__c>();
		Inspection__c inspection;
		for(License__c license : newInspectionList){
			if(license.License_Type__c == 'Renewal'){
				inspection = new Inspection__c();
				inspection.Provider_No__c = license.Provider_No__c;
				if(providerMap != null && providerMap.containsKey(license.Provider_No__c)){
					inspection.Inspector_del__c = providerMap.get(license.Provider_No__c).OwnerId;
					inspection.Estimated_Deadline__c = (providerMap.get(license.Provider_No__c).Renewal_Date__c != null)?providerMap.get(license.Provider_No__c).Renewal_Date__c:null;
				}
				inspection.Type_of_Visit__c = 'Renewal';
				//inspection.Estimated_Deadline__c = 
				inspection.Announced__c = true;
				inspection.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
				inspection.Status__c = 'To be scheduled';
				createVisitList.add(inspection);
			}
		}
		
		insert createVisitList;
	}*/

}