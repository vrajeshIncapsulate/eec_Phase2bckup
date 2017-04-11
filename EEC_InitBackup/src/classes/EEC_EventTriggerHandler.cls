public with sharing class EEC_EventTriggerHandler {
	
	List<Event> newEventList;
	Map<Id,Event> oldEventMap;
	Map<Id,Inspection__c> visitMap;
	Map<Id, List<Task>> visitTaskMap;
	Map<Id,Event> visitEventMap;
	Map<Id,Account> accountMap;
	Map<Id,Contact> contactMap;
	
	public EEC_EventTriggerHandler(List<Event> newList){
		this.newEventList = newList;
	}
	
	public EEC_EventTriggerHandler(List<Event> newList, Map<Id,Event> oldMap){
		this.newEventList = newList;
		this.oldEventMap = oldMap;
	}
	
	public void bulkAfter(){
		Set<Id> visitIdSet = new Set<Id>();
		Set<Id> contactIdSet = new Set<Id>();
		Set<Id> visitAccountSet = new Set<Id>();
		
		visitMap = new Map<Id,Inspection__c>();
		visitTaskMap = new Map<Id, List<Task>>();
		visitEventMap = new Map<Id,Event>();
		
		for(Event evnt : newEventList){
			if(evnt.WhatId != null && String.valueOf(evnt.WhatId).startswith('a04') && evnt.EndDateTime > DateTime.now()){
				visitIdSet.add(evnt.WhatId);
				visitEventMap.put(evnt.WhatId,evnt);
				if(evnt.AccountId != null){
					visitAccountSet.add(evnt.AccountId);
				}
				if(evnt.WhoId != null && String.valueOf(evnt.WhoId).startsWith('003')){
					contactIdSet.add(evnt.WhoId);
				}
			}
		}
		
		if(visitIdSet != null && visitIdSet.size() > 0){
			visitMap = new Map<Id,Inspection__c>([select Id, Status__c,Date_of_Visit__c,Email_Alert_Main_Recipient__c,Email_Alert_Secondary_Recipient__c from Inspection__c where Id in :visitIdSet]);
			List<Task> tskList;
			for(Task tsk :[select Id, Status, whatId from Task where isClosed != true and WhatId in :visitIdSet]){
				if(visitTaskMap.containsKey(tsk.whatId)){
					tsk.Status = 'Completed';
					visitTaskMap.get(tsk.whatId).add(tsk);
				}
				else{
					tskList = new List<Task>();
					tsk.Status = 'Completed';
					tskList.add(tsk);
					visitTaskMap.put(tsk.WhatId,tskList);
				}
			}
		}
		
		if(contactIdSet != null && contactIdSet.size() > 0){
			contactMap = new Map<Id,Contact>([select Id,Email from Contact where Id in :contactIdSet and Email != null]);
		}
		
		if(visitAccountSet != null && visitAccountSet.size() > 0){
			accountMap = new Map<Id,Account>([select Id,Provider_Email__c from Account where Id in :visitAccountSet]);
		}
	}
	
	public void updateTasks(){
		
		List<Task> updateTaskList = new List<Task>();
		if(visitTaskMap != null && visitTaskMap.size()>0){
			for(Id visitId : visitTaskMap.keySet()){
				updateTaskList.addAll(visitTaskMap.get(visitId));
			}
		}
		
		if(updateTaskList != null && updateTaskList.size() > 0){
			update updateTaskList;
		}
	}
	public void updateBeforeVisits(){

		List<Inspection__c> updateVisitList = new List<Inspection__c>();
		String vTime;
		DateTime startTime;
		Event newEvent;
		Account accnt;
		Contact contact;
		if(visitMap != null && visitMap.size() > 0){
			Inspection__c vst;
			for(Id visitId : visitMap.keySet()){
				vst = visitMap.get(visitId);
				newEvent = visitEventMap.get(vst.Id);
				vst.Status__c = 'Scheduled';
				vst.Date_of_Visit__c = newEvent.ActivityDate;
				Integer hr = newEvent.StartDateTime.hour();
				vst.Time_of_visit__c =  (hr <= 12?hr:hr-12) + ':' + (newEvent.StartDateTime.minute() == 0 ?'00': String.ValueOf(newEvent.StartDateTime.minute()))+ ((hr>=12)?' PM':' AM');
				
				//vst.Time_of_visit__c =  newEvent.StartDateTime.hour() + ':' + newEvent.StartDateTime.minute() + ':' + newEvent.StartDateTime.second();
				
				if(newEvent.AccountId != null){
					accnt = accountMap.get(newEvent.AccountId);
				}
				
				if(newEvent.WhoId != null && String.valueOf(newEvent.WhoId).startsWith('003')){
					contact = contactMap.get(newEvent.WhoId);
				}
				if(contact != null && String.isNotBlank(contact.Email)){
					vst.Email_Alert_Main_Recipient__c = contact.Email;
				}
				else if(accnt != null && String.isNotBlank(accnt.Provider_Email__c)){
					vst.Email_Alert_Main_Recipient__c = accnt.Provider_Email__c;
				}
				vst.Email_Alert_Secondary_Recipient__c = newEvent.Additional_Email_to_Copy__c;
				updateVisitList.add(vst);
			}
		}
		
		if(updateVisitList != null && updateVisitList.size() > 0){
			update updateVisitList;
		}
		
	}
	 
	public void updateAfterVisits(){

		List<Inspection__c> updateVisitList = new List<Inspection__c>();
		Event newEvent;
		Event oldEvent;
		Account accnt;
		Contact contact;
		Inspection__c vst;
		String oldAdditional = '';
		String newAdditional = '';
		String oldEmail = '';
		String newEmail = '';
		
		if(visitMap != null && visitMap.size() > 0){
			for(Id visitId : visitMap.keySet()){
				vst = visitMap.get(visitId);
				newEvent = visitEventMap.get(vst.Id);
				oldEvent = oldEventMap.get(newEvent.Id);
				if(newEvent.AccountId != null){
					accnt = accountMap.get(newEvent.AccountId);
				}
				
				if(newEvent.WhoId != null && String.valueOf(newEvent.WhoId).startsWith('003')){
					contact = contactMap.get(newEvent.WhoId);
				}
				
				if(newEvent.StartDateTime != oldEvent.StartDateTime){
					vst.Date_of_Visit__c = newEvent.ActivityDate;
                    Integer hr = newEvent.StartDateTime.hour();
					vst.Time_of_visit__c =  (hr <= 12?hr:hr-12) + ':' + (newEvent.StartDateTime.minute() == 0 ?'00': String.ValueOf(newEvent.StartDateTime.minute()))+ ((hr>=12)?' PM':' AM');
				
					//vst.Time_of_visit__c =  newEvent.StartDateTime.hour() + ':' + newEvent.StartDateTime.minute() + ':' + newEvent.StartDateTime.second();
				}
				oldAdditional = String.isNotBlank(vst.Email_Alert_Secondary_Recipient__c)?vst.Email_Alert_Secondary_Recipient__c:'';
				newAdditional = String.isNotBlank(newEvent.Additional_Email_to_Copy__c)?newEvent.Additional_Email_to_Copy__c:'';
				
				if(oldAdditional != newAdditional){
					vst.Email_Alert_Secondary_Recipient__c = newAdditional;
				}
				
				if(contact != null && String.isNotBlank(contact.Email)){
					newEmail = contact.Email;
				}
				else if(accnt != null && String.isNotBlank(accnt.Provider_Email__c)){
					newEmail = accnt.Provider_Email__c;
				}
				oldEmail = String.isNotBlank(vst.Email_Alert_Main_Recipient__c)?vst.Email_Alert_Main_Recipient__c:'';
				newEmail = String.isNotBlank(newEmail)?newEmail:'';
				
				
				if(oldEmail != newEmail){
					vst.Email_Alert_Main_Recipient__c = newEmail;
				}
				
				updateVisitList.add(vst);
			}
		}
		
		if(updateVisitList != null && updateVisitList.size() > 0){
			update updateVisitList;
		}
		
	}
	
	/*public void sendVisitEventEmails(){
		
		Account accnt;
		Inspection__c visit;
		Contact contact;
		EEC_EmailUtil eu;
		String emailAddress = '';
		
		List<String> toAddresses;
		Id templateId = [select id, name from EmailTemplate where developername = 'X2_Notification_to_Provider_that_a_visit_has_been_scheduled'].id;
		for(Event evnt : newEventList){
			if(evnt.WhatId != null && String.valueOf(evnt.WhatId).startswith('a04') && evnt.EndDateTime > DateTime.now()){
				visit = visitMap.get(evnt.WhatId);
				toAddresses = new List<String>();
				if(evnt.WhoId != null && String.valueOf(evnt.WhoId).startsWith('003')){
					contact = contactMap.get(evnt.WhoId);
				}
				if(evnt.AccountId != null){
					accnt = accountMap.get(evnt.AccountId);
				}
				
				if(contact != null && String.isNotBlank(contact.Email)){
					toAddresses.add(contact.Email);
				}
				else if(accnt != null && String.isNotBlank(accnt.Provider_Email__c)){
					toAddresses.add(accnt.Provider_Email__c);
				}
				
				if(String.isNotBlank(evnt.Additional_Email_to_Copy__c)){
					toAddresses.add(evnt.Additional_Email_to_Copy__c);
				}
				
				if(toAddresses != null && toAddresses.size() > 0){
					eu = new EEC_EmailUtil();
					eu.targetObjectId = (contact !=null)?contact.Id:UserInfo.getUserId();
					
					if(contact !=null){
						eu.whatId = visit.Id;
						eu.saveAsActivity = true;
					}
					eu.toAddresses = toAddresses;
					eu.templateId = templateId;
					eu.sendEmail();
				}
			}
		}
	}*/
	
}