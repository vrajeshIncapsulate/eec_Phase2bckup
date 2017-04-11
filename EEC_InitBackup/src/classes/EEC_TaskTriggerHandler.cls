public with sharing class EEC_TaskTriggerHandler {
	
	List<Task> newTaskList;
	Map<Id,Lead> leadMap;
	
	public EEC_TaskTriggerHandler(List<Task> newList){
		this.newTaskList = newList;
	}
	
	public void bulkAfter(){
		Set<Id> leadIds = new Set<Id>();
		for(Task tsk : newTaskList){
			if(String.isNotBlank(tsk.Subject) && tsk.Subject.contains('75 - FCC PPM Meeting - Certificate of Attendance') && tsk.whoId != null){
				leadIds.add(tsk.WhoId);
			}
		}
		if(leadIds != null && leadIds.size() > 0){
			leadMap = new Map<Id,Lead>([select Id,Status,PPM_Meeting_Attended_Date__c from Lead where Id in :leadIds]);
		}
		
	}
	
	public void updateLeads(){
		List<Lead> updateLeads = new List<Lead>();
		if(leadMap != null && leadMap.size() > 0){
			for(Lead ld : leadMap.values()){
				ld.status = 'Attended';
				if(ld.PPM_Meeting_Attended_Date__c == null){
					ld.PPM_Meeting_Attended_Date__c = Date.Today();
				}
				updateLeads.add(ld);
			}
			update updateLeads;
		}
	}
	
}