global class EEC_VisitAnnouncedEmail implements Database.Batchable <sObject>{
	
	String vQuery = '';
	global EEC_VisitAnnouncedEmail(String query)
    {
        this.vQuery =  query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(vQuery);
    } 
     
    global void execute(Database.BatchableContext BC, List <Inspection__c> visitList)
    {
    	
    	for(Inspection__c visit : visitList){
    		visit.Announced_Visit_Remainder__c = true;
    	}
    	Database.update(visitList);
    	
    	/*Map<Id,Inspection__c> visitIdMap = new Map<Id,Inspection__c>();
    	Map<Id,Contact> contactIdMap;
    	Map<Id,Event> eventIdMap = new Map<Id,Event>();
    	Set<Id> contactSet = new Set<Id>();
    	List<String> toAddresses;
    	for(Inspection__c visit : visitList){
    		visitIdMap.put(visit.Id,visit);
    	}
    	 
    	for(Event evnt : [select Id,WhatId,WhoId,Additional_Email_to_Copy__c from Event where WhatId in :visitIdMap.KeySet() and EndDateTime > :DateTime.now() order by createddate asc]){
    		if(evnt.WhoId != null && String.ValueOf(evnt.WhoId).StartsWith('003')){
    			contactSet.add(evnt.WhoId);
    		}
    		eventIdMap.put(evnt.WhatId,evnt);
    	}
    	
    	contactIdMap = new Map<Id,Contact>([select Id, Email from Contact where Id in :contactSet and Email != null]);
    	Inspection__c visit;
    	Event evnt;
    	Contact cntct;
    	EEC_EmailUtil eu;
    	Boolean hasContactEmail;
    	List<EEC_EmailUtil> euList = new List<EEC_EmailUtil>();
    	
    	Id templateId = [select id, name from EmailTemplate where developername = 'X3_Reminder_to_Provider_that_a_visit_has_been_scheduled'].id;
    	System.debug('****** Before visitIdMap -- '+visitIdMap);
    	if(visitIdMap != null && visitIdMap.size() > 0){
	    	for(Id id : visitIdMap.Keyset()){
	    		cntct = null;
	    		visit = visitIdMap.get(Id);
				toAddresses = new List<String>();
				evnt = eventIdMap.get(visit.Id);
				hasContactEmail = false;
				if(evnt != null){
					if(evnt.WhoId != null){
						cntct = contactIdMap.get(evnt.WhoId);
						if(cntct != null && String.isNotBlank(cntct.Email)){
							toAddresses.add(cntct.Email);
							hasContactEmail = true;
						}
					}
					if(String.isNotBlank(evnt.Additional_Email_to_Copy__c)){
						toAddresses.add(evnt.Additional_Email_to_Copy__c);
					}
				}
				if( !hasContactEmail && String.isNotBlank(visit.Provider_No__c) && String.isNotBlank(visit.Provider_No__r.Provider_Email__c)){
					toAddresses.add(visit.Provider_No__r.Provider_Email__c);
				}
				
				if(toAddresses != null && toAddresses.size() > 0){
					eu = new EEC_EmailUtil();
					eu.targetObjectId = (cntct !=null)?cntct.Id:UserInfo.getUserId();
					eu.toAddresses = toAddresses;
					eu.templateId = templateId;
					eu.whatId = visit.Id;
					eu.saveAsActivity = true;
					eu.sendEmail();
				}
				visit.Announced_Visit_Remainder__c = true;
	    	}
	    	Database.update(visitIdMap.values());
    	}*/
    }
    
    global void finish(Database.BatchableContext BC)
    {
		
    }
}